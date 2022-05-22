#!/usr/bin/env bash

if [ -z "$1" ];then
    echo "Usage: create_symbolic_links.sh <BASEDIR>"
    return 1
fi

BASEDIR=$1

FILES=(
    "bash/.bash_aliases"
    "bash/.bash_exports"
    "bash/.bash_logout"
    "bash/.bash_options"
    "bash/.bash_profile"
    "bash/.bash_prompt"
    "bash/.bash_functions"
    "bash/.bashrc"
    "bash/.inputrc"
    "git/.gitconfig"
    "vim/.vimrc"
)

CONFIG_FILES=(
    "config/starship.toml"
)

echo -e "\e[1;34m[i] Creating symlinks in $HOME/ ...\e[0m"
for file in "${FILES[@]}"; do
    sourceFile="$BASEDIR/$file"
    targetFile="$HOME/$(printf "%s" "$file" | sed "s/.*\/\(.*\)/\1/g")"
    
    ln -sfn "$sourceFile" "$targetFile"
done;
unset file;

echo -e "\e[1;34m[i] Creating symlinks in $HOME/.config/ ...\e[0m"
for file in "${CONFIG_FILES[@]}"; do
    sourceFile="$BASEDIR/$file"
    targetFile="$HOME/.config/$(printf "%s" "$file" | sed "s/.*\/\(.*\)/\1/g")"

    ln -sfn "$sourceFile" "$targetFile"
done;
unset file;

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
