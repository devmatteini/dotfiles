#!/usr/bin/env python3

from os import path
import subprocess

RESET = "\033[0m"
RED = "\033[1;31m"
BLUE = "\033[1;34m"

DOTFILES_DIR = path.dirname(path.dirname(path.abspath(__file__)))
PACKAGES_DIR = path.join(DOTFILES_DIR, "packages")

ESSENTIAL_PACKAGES = [
    "atuin",
    "bat",
    "direnv",
    "docker",
    "eza",
    "fd",
    "firacode",
    "fzf",
    "gnome-tweaks",
    "hyperfine",
    "miniserve",
    "mise",
    "mpv",
    "nodejs",
    "rg",
    "ruff",
    "shellcheck",
    "starship",
    "tldr",
    "vscode",
    "wezterm",
]


def main():
    errors = []

    for package in ESSENTIAL_PACKAGES:
        install_script = path.join(PACKAGES_DIR, package)

        print(f"Installing {BLUE}{package}{RESET}...")
        try:
            subprocess.run(
                install_script, shell=True, check=True, executable="/bin/bash"
            )
        except subprocess.CalledProcessError:
            errors.append(package)
        print("")

    if len(errors) > 0:
        print(f"{RED}Failed to install: {errors}{RESET}")
        exit(1)


if __name__ == "__main__":
    main()
