#!/usr/bin/env python3

import argparse
from typing import Callable, List
import os

BOLD='\033[1m'
RESET='\033[0m'

class Package:
    name:str
    install_command:str

    def __init__(self, name:str, install_command:str) -> None:
        self.name = name
        self.install_command = install_command

def run_installer(packages: List[Package], parser: argparse.ArgumentParser) -> None:
    args = parser.parse_args()

    if args.list:
        for package in packages:
            print(package.name)
        return

    filters= args.filter.split(",") if args.filter else []
    to_intall= filter(lambda x: x.name in filters, packages) if filters else packages
    for package in to_intall:
        print(f'Installing {BOLD}{package.name}{RESET}...')
        os.system(package.install_command)

def join(list: List[str]) -> str:
    return " && ".join(list)

def create_installer(name:str, packages: List[Package]) -> Callable[[], None]:
    parser = argparse.ArgumentParser(description=f'Application installer for {BOLD}{name}{RESET}')
    parser.add_argument('--list', action="store_true", help='List all packages')
    parser.add_argument('--filter', type=str, help='Comma separated list of packages to install')

    return lambda: run_installer(packages, parser)
