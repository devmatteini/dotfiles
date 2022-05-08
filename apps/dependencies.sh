#!/bin/bash

function has_installed() {
  if ! command -V "$1" >/dev/null; then
    echo "$1 command missing" >&2
    exit 1
  fi
}

function install_flatpak(){
  sudo apt install -y flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Create common directories
mkdir -p "$HOME"/.local/share/bash-completion/completions
mkdir -p "$HOME"/dev/

sudo apt update
sudo add-apt-repository -y universe
sudo apt update

sudo apt install -y build-essential \
  curl \
  wget \
  git \
  python3-pip \
  python3-dev \
  python3-setuptools

install_flatpak

# Cleanup
sudo apt autoremove -y

# Setup dra - https://github.com/devmatteini/dra
has_installed dra
dra completion bash >"$HOME"/.local/share/bash-completion/completions/dra
