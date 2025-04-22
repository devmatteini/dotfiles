#!/usr/bin/env bash

set -euo pipefail

white="\e[1;37m"
reset="\e[0m"
green="\e[1;32m"
underline="\e[4m"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$BASEDIR"/bootstrap/file_system.sh
"$BASEDIR"/bootstrap/configs.sh "$BASEDIR"
sudo "$BASEDIR"/bootstrap/system-configs.sh "$BASEDIR"
"$BASEDIR"/bootstrap/dependencies.sh
"$BASEDIR"/bootstrap/gnome-settings.sh

echo -e "${green}Bootstrap completed!$reset\n"
echo -e "If you want to set ${underline}zsh${reset} as default shell run:\n${white}chsh -s \$(which zsh)${reset}"
