#!/usr/bin/env python3

import argparse
from typing import Callable, List, Optional
import os

BOLD='\033[1m'
RESET='\033[0m'

class Package:
    name:str
    install_command:str

    def __init__(self, name:str, install_command:str) -> None:
        self.name = name
        self.install_command = install_command


def __filter_or_exclude(packages: List[Package], to_filter: List[str], to_exclude: List[str]) -> List[Package]:
    if to_filter:
        return filter(lambda x: x.name in to_filter, packages)
    if to_exclude:
        return filter(lambda x: x.name not in to_exclude, packages)
    return packages

def __str_to_array(value: Optional[str]) -> List[str]:
    return value.split(",") if value else []

def run_installer(packages: List[Package], parser: argparse.ArgumentParser) -> None:
    args = parser.parse_args()

    if args.list:
        for package in packages:
            print(package.name)
        return

    to_filter = __str_to_array(args.filter)
    to_exclude = __str_to_array(args.exclude)
    to_intall = __filter_or_exclude(packages, to_filter, to_exclude)
    for package in to_intall:
        print(f'Installing {BOLD}{package.name}{RESET}...')
        os.system(package.install_command)

def join(list: List[str]) -> str:
    return " && ".join(list)

def create_installer(name:str, packages: List[Package]) -> Callable[[], None]:
    parser = argparse.ArgumentParser(description=f'Application installer for {BOLD}{name}{RESET}')
    parser.add_argument('--list', action="store_true", help='List all packages')
    parser.add_argument('--filter', type=str, help='Comma separated list of packages to install')
    parser.add_argument('--exclude', type=str, help='Comma separated list of packages to exclude')

    return lambda: run_installer(packages, parser)
