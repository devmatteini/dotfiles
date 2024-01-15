#!/usr/bin/env bash

if [ -z "$1" ];then
    echo "Usage: $(basename "${BASH_SOURCE[0]}") <BASEDIR>"
    exit 1
fi

BASEDIR=$1

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

# $1 = source_directory, $2 = target_directory
symlink_dir_files() {
    local directory=$1
    local target_directory=$2
    local full_path="$BASEDIR/$directory"

    echo -e "\e[1;34m[i] Creating symlinks for '$directory' in '$target_directory'\e[0m"

    readarray -t DIR_FILES < <(find "$full_path" -maxdepth 1 -type f)
    
    for file in "${DIR_FILES[@]}"; do
        filename=$(basename "$file")

        source_file=$file
        target_file="$target_directory/$filename"

        create_symlink "$source_file" "$target_file"
    done
}

# $1 = source_directory, $2 = target_directory
symlink_dirs() {
    local directory=$1
    local target_directory=$2

    # NOTE: -mindepth 1 is to avoid including $directory itself
    readarray -t DIRS < <(find "$directory" -maxdepth 1 -mindepth 1 -type d)

    for source_dir in "${DIRS[@]}"; do
        dir_name=$(basename "$source_dir")
        target_dir="$target_directory/$dir_name"

        mkdir -p "$target_dir"
        symlink_dir_files "$source_dir" "$target_dir"
    done;
}

symlink_dir_files "bash" "$HOME"
symlink_dir_files "git" "$HOME"
symlink_dir_files "vim" "$HOME"

symlink_dir_files "config" "$HOME/.config"
symlink_dirs "config" "$HOME/.config"

echo -e "\e[1;32m[✓] Symlinks created succesfully.\e[0m"
