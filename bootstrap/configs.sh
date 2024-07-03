#!/usr/bin/env bash

if [ -z "$1" ];then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <BASEDIR>"
    exit 1
fi

BASEDIR=$1
CONFIGS="$BASEDIR/configs"

# $1 = source_file, $2 = target_file
create_symlink() {
    local source_file=$1
    local target_file=$2

    if [[ $DEBUG != "true" ]]; then
        ln -sfn "$source_file" "$target_file"
    else
        echo "$source_file -> $target_file"
    fi
}

# $1 = relative_source_file, $2 = target_directory
symlink_file() {
    file=$1
    target_directory=$2

    echo -e "\e[1;34m[i] Creating symlinks for '$file' in '$target_directory'\e[0m"

    filename=$(basename "$file")

    source_file="$file"
    target_file="$target_directory/$filename"

    create_symlink "$source_file" "$target_file"
}

# $1 = source_directory, $2 = target_directory
symlink_dir_files() {
    local directory=$1
    local target_directory=$2

    echo -e "\e[1;34m[i] Creating symlinks for '$directory' in '$target_directory'\e[0m"

    readarray -t DIR_FILES < <(find "$directory" -maxdepth 1 -type f)
    
    for file in "${DIR_FILES[@]}"; do
        filename=$(basename "$file")

        source_file=$file
        target_file="$target_directory/$filename"

        create_symlink "$source_file" "$target_file"
    done
}

# $1 = source_directory, $2 = target_directory
symlink_dir() {
    local directory=$1
    local target_directory=$2

    dir_name=$(basename "$directory")
    target_dir="$target_directory/$dir_name"

    mkdir -p "$target_dir"
    symlink_dir_files "$directory" "$target_dir"
}

symlink_dir_files "$CONFIGS/bash" "$HOME"
symlink_dir_files "$CONFIGS/zsh" "$HOME"
symlink_file "$CONFIGS/.gitconfig" "$HOME"
symlink_file "$CONFIGS/.vimrc" "$HOME"
symlink_file "$CONFIGS/starship.toml" "$HOME/.config"
symlink_dir "$CONFIGS/wezterm" "$HOME/.config"
symlink_dir "$CONFIGS/atuin" "$HOME/.config"

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
