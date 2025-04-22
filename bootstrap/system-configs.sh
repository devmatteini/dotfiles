#!/usr/bin/env bash

set -euo pipefail

if [ -z "$1" ];then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <BASEDIR>"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root to configure system configuration files"
    exit 1
fi

BASEDIR=$1
CONFIGS="$BASEDIR/configs"

source "$BASEDIR/bootstrap/libconfigs.sh"

symlink_dir "$CONFIGS/docker" "/etc"

echo -e "\e[1;32m[✓] System configs symlinks created succesfully.\e[0m"
