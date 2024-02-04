#!/usr/bin/env python3

import argparse
from typing import List, Optional
import subprocess

BOLD = "\033[1m"
RESET = "\033[0m"
RED = "\033[1;31m"


class Package:
    name: str
    install_command: str

    def __init__(self, name: str, install_command: str) -> None:
        self.name = name
        self.install_command = install_command


def __filter_or_exclude(
    packages: List[Package], to_filter: List[str], to_exclude: List[str]
) -> List[Package]:
    if to_filter:
        return filter(lambda x: x.name in to_filter, packages)
    if to_exclude:
        return filter(lambda x: x.name not in to_exclude, packages)
    return packages


def __str_to_array(value: Optional[str]) -> List[str]:
    return value.split(",") if value else []


def __install_packages(packages: List[Package], parser: argparse.ArgumentParser):
    args = parser.parse_args()

    if args.list:
        for package in packages:
            print(package.name)
        return

    to_filter = __str_to_array(args.filter)
    to_exclude = __str_to_array(args.exclude)
    to_install = __filter_or_exclude(packages, to_filter, to_exclude)

    errors = []

    for package in to_install:
        print(f"Installing {BOLD}{package.name}{RESET}...")
        try:
            subprocess.run(package.install_command, shell=True, check=True)
        except subprocess.CalledProcessError:
            errors.append(package.name)
        print("")

    if len(errors) > 0:
        print(f"{RED}Failed to install: {errors}{RESET}")
        exit(1)


def join(list: List[str]) -> str:
    return " && ".join(list)


def installer(name: str, packages: List[Package]):
    parser = argparse.ArgumentParser(
        description=f"Application installer for {BOLD}{name}{RESET}"
    )
    parser.add_argument("--list", "-l", action="store_true", help="List all packages")
    parser.add_argument(
        "--filter", "-f", type=str, help="Comma separated list of packages to install"
    )
    parser.add_argument(
        "--exclude", "-e", type=str, help="Comma separated list of packages to exclude"
    )

    __install_packages(packages, parser)


def bash_completion_for(file_name: str) -> str:
    return f"~/.local/share/bash-completion/completions/{file_name}"


def zsh_completion_for(file_name: str) -> str:
    name = file_name if file_name.startswith("_") else f"_{file_name}"
    return f"~/.local/share/zsh-completion/{name}"
