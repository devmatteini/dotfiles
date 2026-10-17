import argparse
import os
import shutil
import stat
import tempfile
from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from pathlib import Path


HARNESSES = ("claude", "opencode")
USAGE = "usage: sb <claude|opencode> [NONO_OPTIONS]"
RESERVED_OPTIONS = ("--workdir", "--allow-cwd", "--profile", "--config", "--extends")
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


class GrantParser(argparse.ArgumentParser):
    def error(self, message: str):
        raise ValueError(message)


@dataclass(frozen=True)
class Directory:
    path: Path

    @classmethod
    def try_from_path(cls, path: Path) -> "Directory":
        metadata = path.lstat()
        if not stat.S_ISDIR(metadata.st_mode):
            raise ValueError(f"scan path is not a directory: {path}")
        if path.name.startswith(".env"):
            raise ValueError(f"unsafe .env path (directory): {path}")
        return cls(path)


def parse_args(
    argv: Sequence[str], environment: Mapping[str, str]
) -> tuple[str, list[str], list[str], list[str]]:
    if not argv or argv[0] not in HARNESSES:
        raise ValueError(USAGE)

    options = list(argv[1:])
    for option in options:
        if option == "--":
            raise ValueError("the -- separator is reserved by sb")
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

    parser = GrantParser(add_help=False, allow_abbrev=False, exit_on_error=False)
    for flags in (("-a", "--allow"), ("-r", "--read"), ("-w", "--write")):
        parser.add_argument(*flags, action="append", dest="directories")
    for flag in ("--allow-file", "--read-file", "--write-file"):
        parser.add_argument(flag, action="append", dest="files")
    try:
        grants, _ = parser.parse_known_args(options)
    except argparse.ArgumentError as error:
        raise ValueError(str(error)) from error

    return argv[0], options, grants.directories or [], grants.files or []


def resolve(path: str, workdir: Path) -> Path:
    candidate = Path(path)
    if not candidate.is_absolute():
        candidate = workdir / candidate
    return candidate.resolve(strict=True)


def validate_env_file(path: Path, metadata: os.stat_result) -> None:
    if stat.S_ISLNK(metadata.st_mode):
        raise ValueError(f"unsafe .env path (symlink): {path}")
    if stat.S_ISDIR(metadata.st_mode):
        raise ValueError(f"unsafe .env path (directory): {path}")
    if not stat.S_ISREG(metadata.st_mode):
        raise ValueError(f"unsafe .env path (special file): {path}")
    if metadata.st_nlink != 1:
        raise ValueError(f"unsafe .env path (hard-linked file): {path}")


def find_env_files(
    directories: Sequence[Directory], files: Sequence[Path]
) -> list[Path]:
    found: list[Path] = []

    def scan(directory: Path) -> None:
        with os.scandir(directory) as entries:
            for entry in entries:
                path = Path(entry.path)
                metadata = entry.stat(follow_symlinks=False)
                if path.name.startswith(".env"):
                    validate_env_file(path, metadata)
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
        if path.name.startswith(".env"):
            validate_env_file(path, path.lstat())
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
        if unresolved.name.startswith(".env"):
            validate_env_file(unresolved, unresolved.lstat())
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


def run(argv: Sequence[str], environment: Mapping[str, str], workdir: Path) -> None:
    harness, nono_options, directory_grants, file_grants = parse_args(argv, environment)

    bwrap, nono = check_installed_tools()

    directories, files = sandbox_fs_context(workdir, directory_grants, file_grants)
    env_files = find_env_files(directories, files)

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
        for path in env_files:
            command.extend(("--perms", "000", "--ro-bind-data", str(fd), str(path)))
        command.extend(
            (
                "--",
                nono,
                "run",
                "--profile",
                harness,
                "--allow-cwd",
                *nono_options,
                "--",
                harness,
            )
        )
        os.execvp(bwrap, command)
