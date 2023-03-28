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

CONFIG_DIRS=(
    "config/wezterm"
)

# NOTE: https://www.shellcheck.net/wiki/SC2207
readarray -t SCRIPTS_FILES < <(find "$BASEDIR/scripts" -maxdepth 1 -type f -printf '%f\n')

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

echo -e "\e[1;34m[i] Creating directories in $HOME/.config/ ...\e[0m"
for dir in "${CONFIG_DIRS[@]}"; do
    sourceDir="$BASEDIR/$dir"
    targetDir="$HOME/.config/$(printf "%s" "$dir" | sed "s/.*\/\(.*\)/\1/g")"

    mkdir -p "$targetDir"
    files=($(ls -A "$sourceDir"))
    echo -e "\e[1;34m    [i] Creating symlinks in $targetDir ...\e[0m"
    for file in "${files[@]}"; do
        sourceFile="$sourceDir/$file"
        targetFile="$targetDir/$file"

        ln -sfn "$sourceFile" "$targetFile"
    done;
done;

echo -e "\e[1;34m[i] Creating symlinks in $HOME/.local/bin ...\e[0m"
for file in "${SCRIPTS_FILES[@]}"; do
    sourceFile="$BASEDIR/scripts/$file"
    targetFile="$HOME/.local/bin/$file"

    ln -sfn "$sourceFile" "$targetFile"
done;
unset file;

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
