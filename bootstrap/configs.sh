#!/usr/bin/env bash

set -euo pipefail

if [ -z "$1" ];then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <BASEDIR>"
    exit 1
fi

BASEDIR=$1
CONFIGS="$BASEDIR/configs"

source "$BASEDIR/bootstrap/libconfigs.sh"

symlink_dir_files "$CONFIGS/bash" "$HOME"
symlink_dir_files "$CONFIGS/zsh" "$HOME"
symlink_dir_files "$CONFIGS/shell" "$HOME"
symlink_file "$CONFIGS/.gitconfig" "$HOME"
symlink_file "$CONFIGS/.vimrc" "$HOME"
symlink_file "$CONFIGS/starship.toml" "$HOME/.config"
symlink_dir "$CONFIGS/wezterm" "$HOME/.config"
symlink_dir "$CONFIGS/atuin" "$HOME/.config"
symlink_file "$CONFIGS/mpv.conf" "$HOME/.config/mpv"

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
