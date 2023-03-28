#!/usr/bin/env bash

RESET="\e[0m"
RED="\e[1;31m"

mkcd(){
    mkdir -p "$1" && cd "$_" || return 1
}

change-aws-profile(){
    local profile
    profile=$(aws configure list-profiles | fzf --cycle --layout=reverse)
    if [[ -z $profile ]]; then
        echo "Nothing selected"
        return 0
    fi
    export AWS_PROFILE="$profile"
}

has_installed() {
    if ! which "$1" > /dev/null; then
        echo -e "${RED}$1 is not installed${RESET}"
        return 1
    fi
}

download_yt_playlist_mp3() {
    has_installed youtube-dl
    has_installed ffmpeg

    youtube-dl --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --output "%(title)s.%(ext)s" --yes-playlist "$1"
}
