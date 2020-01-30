#!/bin/bash

BASEDIR="$(cd .. && pwd)"

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

for file in ${FILES[@]}; do
    sourceFile="$BASEDIR/$file"
    targetFile="$HOME/$(printf "%s" "$file" | sed "s/.*\/\(.*\)/\1/g")"
    
    ln -sfn $sourceFile $targetFile
done;
unset file;