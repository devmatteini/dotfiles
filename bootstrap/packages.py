#!/usr/bin/env python3

from os import path
import subprocess
import argparse
from typing import Literal

RESET = "\033[0m"
RED = "\033[1;31m"
BLUE = "\033[1;34m"

DOTFILES_DIR = path.dirname(path.dirname(path.abspath(__file__)))
PACKAGES_DIR = path.join(DOTFILES_DIR, "packages")

ESSENTIAL_PACKAGES = [
    "atuin",
    "bat",
    "clipboard",
    "direnv",
    "docker",
    "eza",
    "fd",
    "firacode",
    "fzf",
    "gh",
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

DESKTOP_PACKAGES = [
    "gimp",
    "gnome-extensions",
    "gnome-weather",
    "google-chrome",
    "jetbrains",
    "jetbrains-toolbox",
    "libreoffice",
    "localsend",
    "obsidian",
    "spotify",
]

parser = argparse.ArgumentParser(description="Install packages")
parser.add_argument(
    "--preset",
    "-p",
    choices=["essential", "desktop"],
    default="essential",
    help="Packages preset to install",
)


def packages_by_preset(preset: Literal["essential", "desktop"]) -> list[str]:
    match preset:
        case "essential":
            return ESSENTIAL_PACKAGES
        case "desktop":
            return DESKTOP_PACKAGES
        case _:
            raise ValueError(f"Invalid preset: {preset}")


def main():
    args = parser.parse_args()

    packages = packages_by_preset(args.preset)
    errors = []

    for package in packages:
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
