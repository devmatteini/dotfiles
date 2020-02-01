#!/bin/bash

if [ -z $1 ];then
    echo "Usage: create_symbolic_links.sh <BASEDIR>"
    return 1
fi

BASEDIR=$1

FILES=(
    "shell/.bash_aliases"
    "shell/.bash_exports"
    "shell/.bash_logout"
    "shell/.bash_options"
    "shell/.bash_profile"
    "shell/.bash_prompt"
    "shell/.bashrc"
    "shell/.inputrc"
    "git/.gitconfig"
    "vim/.vimrc"
)

echo -e "\e[1;34m[i] Creating symlinks in $HOME/ ...\e[0m"

for file in ${FILES[@]}; do
    sourceFile="$BASEDIR/$file"
    targetFile="$HOME/$(printf "%s" "$file" | sed "s/.*\/\(.*\)/\1/g")"
    
    ln -sfn $sourceFile $targetFile
done;
unset file;

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"