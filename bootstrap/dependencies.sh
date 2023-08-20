#!/usr/bin/env bash

set -euo pipefail

# https://flathub.org/setup/Ubuntu
function install_flatpak(){
  sudo apt install -y flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# https://github.com/devmatteini/dra
function install_dra(){
  TMP_DIR=$(mktemp --directory)
  ARCHIVE="$TMP_DIR/dra.tar.gz"

  # Download latest linux musl release asset (https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8)
  curl -s https://api.github.com/repos/devmatteini/dra/releases/latest \
  | grep "browser_download_url.*linux-musl" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -O "$ARCHIVE" -i -

  # Extract archive and move binary to home directory
  tar xf "$ARCHIVE" --strip-components=1 -C "$TMP_DIR"
  mv "$TMP_DIR"/dra "$HOME"/.local/bin/dra

  # Post installation setup
  dra completion bash >"$HOME"/.local/share/bash-completion/completions/dra
  # Create symlink to be able to use dra as superuser (for example when installing .deb assets)
  sudo ln -sf "$HOME"/.local/bin/dra /usr/local/bin/dra
}

function setup_git(){
  # Check out this guide: https://askubuntu.com/questions/773455/what-is-the-correct-way-to-use-git-with-gnome-keyring-and-https-repos
  sudo apt install -y libsecret-1-0 libsecret-1-dev
  sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret

  # Install syntax-highlighting pager and diff output
  # https://github.com/dandavison/delta
  dra download -i -s "delta-{tag}-x86_64-unknown-linux-gnu.tar.gz" -o ~/.local/bin dandavison/delta
}

sudo apt update
sudo add-apt-repository -y universe
sudo apt update

sudo apt install -y build-essential \
  curl \
  wget \
  python3-pip \
  python3-dev \
  python3-setuptools \
  pipx \
  libfuse2 \
  fonts-firacode

install_flatpak
install_dra
setup_git

# Cleanup
sudo apt autoremove -y
