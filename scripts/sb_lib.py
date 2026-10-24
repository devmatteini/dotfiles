import argparse
import os
import shlex
import shutil
import stat
import tempfile
from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from fnmatch import fnmatchcase
from pathlib import Path


HARNESSES = ("claude", "opencode")
RESERVED_OPTIONS = ("--workdir", "--allow-cwd", "--profile", "--config", "--extends")
SANDBOX_TYPE_OPTIONS = {
    # https://github.com/nolabs-ai/nono/issues/1640
    # https://github.com/nolabs-ai/nono/issues/1792
    "android": ("--sandbox-policy", "landlock"),
}
SECRET_FILE_PATTERNS = (".env*", "signing.properties")
EXCLUDED_SCAN_DIRECTORIES = frozenset(
    {
        # Version control and workspaces
        ".git",
        ".repos",
        # Editors
        ".idea",
        ".vscode",
        # JavaScript and TypeScript
        ".netlify",
        ".next",
        ".nuxt",
        ".pnpm-store",
        ".serverless",
        ".svelte-kit",
        ".turbo",
        ".vite",
        ".webpack",
        "coverage",
        "node_modules",
        # Java and Kotlin
        ".gradle",
        ".kotlin",
        # Python
        ".mypy_cache",
        ".nox",
        ".pytest_cache",
        ".ruff_cache",
        ".tox",
        ".venv",
        "__pycache__",
        "site-packages",
        "venv",
        # Go
        "vendor",
        # Build outputs shared by multiple ecosystems
        "build",
        "dist",
        "out",
        "target",
    }
)
HOST_DOCKER_SOCKET_PATHS = (Path("/run/docker.sock"), Path("/var/run/docker.sock"))
TEMP_ROOT = Path("/tmp")

BOLD = "\033[1m"
RESET = "\033[0m"


def is_secret_file(path: Path) -> bool:
    return any(fnmatchcase(path.name, pattern) for pattern in SECRET_FILE_PATTERNS)


def create_parser(
    *, add_help: bool = True, usage: str | None = None
) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="sb",
        usage=usage,
        allow_abbrev=False,
        add_help=add_help,
    )
    parser.add_argument("harness", choices=HARNESSES)
    parser.add_argument(
        "-t",
        "--type",
        choices=SANDBOX_TYPE_OPTIONS,
        help="Sandbox type to customize configuration",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report blocked secrets and bwrap command without executing it",
    )
    return parser


@dataclass(frozen=True)
class CliArgs:
    harness: str
    dry_run: bool
    nono_options: list[str]
    directory_grants: list[str]
    file_grants: list[str]


@dataclass(frozen=True)
class Directory:
    path: Path

    @classmethod
    def try_from_path(cls, path: Path) -> "Directory":
        metadata = path.lstat()
        if not stat.S_ISDIR(metadata.st_mode):
            raise ValueError(f"scan path is not a directory: {path}")
        if is_secret_file(path):
            raise ValueError(f"unsafe secret path (directory): {path}")
        return cls(path)


def parse_args(argv: Sequence[str], environment: Mapping[str, str]) -> CliArgs:
    if "--" in argv:
        raise ValueError("the -- separator is reserved by sb")

    parser = create_parser(usage="%(prog)s [-h] <claude|opencode> [NONO_OPTIONS]")
    for flags in (("-a", "--allow"), ("-r", "--read"), ("-w", "--write")):
        parser.add_argument(*flags, action="append", dest="directories")
    for flag in ("--allow-file", "--read-file", "--write-file"):
        parser.add_argument(flag, action="append", dest="files")
    arguments, _ = parser.parse_known_args(argv)

    passthrough_parser = create_parser(add_help=False)
    _, options = passthrough_parser.parse_known_args(argv)

    if arguments.type:
        options[:0] = SANDBOX_TYPE_OPTIONS[arguments.type]

    for option in options:
        if option.startswith("--allow-unix-socket"):
            raise ValueError(f"unsupported filesystem grant: {option}")
        if any(
            option == reserved or option.startswith(f"{reserved}=")
            for reserved in RESERVED_OPTIONS
        ) or option.startswith(("-p", "-c")):
            raise ValueError(f"option reserved by sb: {option}")

    for variable in ("NONO_ALLOW", "NONO_PROFILE"):
        if environment.get(variable):
            raise ValueError(f"{variable} is unsupported; use explicit CLI options")

    return CliArgs(
        harness=arguments.harness,
        dry_run=arguments.dry_run,
        nono_options=options,
        directory_grants=arguments.directories or [],
        file_grants=arguments.files or [],
    )


def resolve(path: str, workdir: Path) -> Path:
    candidate = Path(path)
    if not candidate.is_absolute():
        candidate = workdir / candidate
    return candidate.resolve(strict=True)


def validate_secret_file(path: Path, metadata: os.stat_result) -> None:
    if stat.S_ISLNK(metadata.st_mode):
        raise ValueError(f"unsafe secret path (symlink): {path}")
    if stat.S_ISDIR(metadata.st_mode):
        raise ValueError(f"unsafe secret path (directory): {path}")
    if not stat.S_ISREG(metadata.st_mode):
        raise ValueError(f"unsafe secret path (special file): {path}")
    if metadata.st_nlink != 1:
        raise ValueError(f"unsafe secret path (hard-linked file): {path}")


def find_secret_files(
    directories: Sequence[Directory], files: Sequence[Path]
) -> list[Path]:
    found: list[Path] = []

    def scan(directory: Path) -> None:
        with os.scandir(directory) as entries:
            for entry in entries:
                path = Path(entry.path)
                metadata = entry.stat(follow_symlinks=False)
                if is_secret_file(path):
                    validate_secret_file(path, metadata)
                    if path not in found:
                        found.append(path)
                elif (
                    stat.S_ISDIR(metadata.st_mode)
                    and path.name not in EXCLUDED_SCAN_DIRECTORIES
                ):
                    scan(path)

    for directory in directories:
        scan(directory.path)
    for path in files:
        if is_secret_file(path):
            validate_secret_file(path, path.lstat())
            if path not in found:
                found.append(path)
    return found


def sandbox_fs_context(
    workdir: Path, directory_grants: Sequence[str], file_grants: Sequence[str]
) -> tuple[list[Directory], list[Path]]:
    directories = [Directory.try_from_path(workdir)]
    for grant in directory_grants:
        directory = Directory.try_from_path(resolve(grant, workdir))
        if directory not in directories:
            directories.append(directory)

    files: list[Path] = []
    for grant in file_grants:
        unresolved = Path(grant)
        if not unresolved.is_absolute():
            unresolved = workdir / unresolved
        if is_secret_file(unresolved):
            validate_secret_file(unresolved, unresolved.lstat())
        path = resolve(grant, workdir)
        if not path.is_file():
            raise ValueError(f"file grant is not a regular file: {path}")
        if path not in files:
            files.append(path)

    return directories, files


def check_installed_tools():
    bwrap = shutil.which("bwrap")
    nono = shutil.which("nono")
    if not bwrap or not nono:
        raise RuntimeError(f"{('bwrap' if not bwrap else 'nono')} not found in PATH")
    return bwrap, nono


def prepare_temp_dir(harness: str) -> Path:
    temp_dir = TEMP_ROOT / f"sb-{harness}-{os.getuid()}"
    try:
        temp_dir.mkdir(mode=0o700)
    except FileExistsError:
        pass

    metadata = temp_dir.lstat()
    if stat.S_ISLNK(metadata.st_mode):
        raise RuntimeError(f"temporary directory is a symlink: {temp_dir}")
    if not stat.S_ISDIR(metadata.st_mode):
        raise RuntimeError(f"temporary path is not a directory: {temp_dir}")
    if metadata.st_uid != os.getuid():
        raise RuntimeError(f"temporary directory belongs to another user: {temp_dir}")
    if stat.S_IMODE(metadata.st_mode) != 0o700:
        raise RuntimeError(f"temporary directory permissions are not 0700: {temp_dir}")
    return temp_dir


def build_child_environment(
    environment: Mapping[str, str], temp_dir: Path
) -> dict[str, str]:
    child_environment = dict(environment)
    child_environment["TMPDIR"] = str(temp_dir)
    return child_environment


def prepare_nono_docker_runtime(environment: Mapping[str, str]) -> Path:
    xdg_runtime = environment.get("XDG_RUNTIME_DIR")
    if not xdg_runtime:
        raise RuntimeError("XDG_RUNTIME_DIR is not set")
    runtime_root = Path(xdg_runtime)
    if not runtime_root.is_absolute():
        raise RuntimeError("XDG_RUNTIME_DIR must be absolute")

    runtime_dir = runtime_root / "nono-docker"
    try:
        metadata = runtime_dir.lstat()
    except FileNotFoundError:
        runtime_dir.mkdir(mode=0o700)
        metadata = runtime_dir.lstat()

    if stat.S_ISLNK(metadata.st_mode):
        raise RuntimeError(f"nono Docker runtime directory is a symlink: {runtime_dir}")
    if not stat.S_ISDIR(metadata.st_mode):
        raise RuntimeError(
            f"nono Docker runtime path is not a directory: {runtime_dir}"
        )
    if metadata.st_uid != os.getuid():
        raise RuntimeError(
            f"nono Docker runtime directory belongs to another user: {runtime_dir}"
        )
    runtime_dir.chmod(0o700)
    return runtime_dir


def existing_host_docker_sockets() -> list[Path]:
    sockets: list[Path] = []
    for path in HOST_DOCKER_SOCKET_PATHS:
        if not path.exists():
            continue
        target = path.resolve(strict=True)
        if target not in sockets:
            sockets.append(target)
    return sockets


def report(secret_files: list[Path], bwrap_command: list[str], workdir: Path):
    print(f"{BOLD}Blocked secret paths:{RESET}")
    if secret_files:
        for path in secret_files:
            print(f" {os.path.relpath(path, workdir)}")
    else:
        print(" none")
    print(f"\n{BOLD}Bubblewrap command:{RESET}")
    print(shlex.join(bwrap_command))


def build_harness_command(harness: str, environment: Mapping[str, str]) -> list[str]:
    command = [harness]
    if harness == "claude":
        home = environment.get("HOME")
        if not home:
            raise RuntimeError("HOME is not set")
        command.extend(
            (
                "--settings",
                str(Path(home) / ".claude/settings-nono.json"),
                "--setting-sources",
                "project,local",
            )
        )
    return command


def run(argv: Sequence[str], environment: Mapping[str, str], workdir: Path) -> None:
    args = parse_args(argv, environment)

    bwrap, nono = check_installed_tools()
    temp_dir = prepare_temp_dir(args.harness)
    child_environment = build_child_environment(environment, temp_dir)
    prepare_nono_docker_runtime(child_environment)

    directories, files = sandbox_fs_context(
        workdir, args.directory_grants, args.file_grants
    )
    secret_files = find_secret_files(directories, files)

    harness_command = build_harness_command(args.harness, child_environment)

    with tempfile.TemporaryFile() as placeholder:
        fd = placeholder.fileno()
        os.set_inheritable(fd, True)
        command = [
            bwrap,
            "--dev-bind",
            "/",
            "/",
            "--chdir",
            str(workdir),
            "--die-with-parent",
        ]
        for path in secret_files:
            command.extend(("--perms", "000", "--ro-bind-data", str(fd), str(path)))
        for path in existing_host_docker_sockets():
            command.extend(("--perms", "000", "--ro-bind-data", str(fd), str(path)))
        command.extend(
            (
                "--",
                nono,
                "run",
                "--profile",
                args.harness,
                "--allow-cwd",
                "--allow",
                str(temp_dir),
                *args.nono_options,
                "--",
                *harness_command,
            )
        )
        if args.dry_run:
            report(secret_files, command, workdir)
            return
        os.execvpe(bwrap, command, child_environment)
