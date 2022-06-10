#!/usr/bin/env bash

RESET="\e[0m"
RED="\e[1;31m"
BLUE="\e[1;34m"
GREEN="\e[1;32m"
PURPLE="\e[1;35m"

mkcd(){
    mkdir -p "$1" && cd "$_" || return 1
}

upgrade_terraform(){
    if [ -z "$1" ];then
        echo "Usage: upgrade_terraform <version>"
        return 1
    fi
    
    version=$1
    
    echo -ne "${BLUE}[-] Downloading terraform $version...${RESET}"
    wget -q https://releases.hashicorp.com/terraform/"$version"/terraform_"$version"_linux_amd64.zip
    echo -ne "\r${GREEN}[✔] Download complete${RESET}\e[K\n"
    
    echo -ne "${BLUE}[-] Unzipping terraform_${version}_linux_amd64.zip...${RESET}"
    unzip -q terraform_"$version"_linux_amd64.zip
    echo -ne "\r${GREEN}[✔] Unzip complete${RESET}\e[K\n"
    
    echo -ne "${PURPLE}[i] Move terraform to $HOME/.local/bin/${RESET}"
    mv terraform "$HOME/.local/bin/"
    echo -ne "\r${GREEN}[✔] Moved terraform to $HOME/.local/bin/${RESET}\e[K\n"
    
    # Cleanup
    echo -e "${BLUE}[i] Cleanup${RESET}\n"
    rm terraform_"$version"_linux_amd64.zip
    
    terraform --version
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
