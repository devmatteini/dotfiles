#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <path/to/file.dconf>"
    exit 1
fi

if [[ ! -e "$1" ]];then
    echo -e "\e[1;31m[X] File ${1} does not exist\e[0m"
    exit 1
fi

echo -e "\e[1;34m[i] Loading ${1} in /org/gnome/terminal/legacy/profiles:/\e[0m"

if dconf load /org/gnome/terminal/legacy/profiles:/ < "$1"; then
    echo -e "\e[1;32m[✓] Loaded ${1} succesfully.\e[0m"
else
    echo -e "\e[1;31m[X] Cannot load ${1} in /org/gnome/terminal/legacy/profiles:/\e[0m"
fi
