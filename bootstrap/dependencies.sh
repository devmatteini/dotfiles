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
  | grep "browser_download_url.*x86_64-unknown-linux-musl" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -O "$ARCHIVE" -i -

  # Extract archive and move binary to home directory
  tar xf "$ARCHIVE" --strip-components=1 -C "$TMP_DIR"
  mv "$TMP_DIR"/dra "$HOME"/.local/bin/dra

  # Post installation setup
  dra completion bash >"$HOME"/.local/share/bash-completion/completions/dra
  dra completion zsh >"$HOME/.local/share/zsh-completion/_dra"
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
  
  delta --generate-completion bash >"$HOME"/.local/share/bash-completion/completions/delta
  delta --generate-completion zsh >"$HOME/.local/share/zsh-completion/_delta"
}

function setup_pipx(){
  local python_argcomplete=""
  if command -v register-python-argcomplete3 > /dev/null; then
      python_argcomplete="register-python-argcomplete3"
  elif command -v register-python-argcomplete > /dev/null; then
      python_argcomplete="register-python-argcomplete"
  else
    echo "Cannot find 'register-python-argcomplete', skipping setup_pipx"
    return
  fi

  "$python_argcomplete" pipx >"$HOME"/.local/share/bash-completion/completions/pipx 
}

function install_zsh_plugins(){
  sudo apt install -y zsh-autosuggestions
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab "$HOME/.local/share/fzf-tab"
}

sudo apt update
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update

# Remove old git version
sudo apt remove -y git
sudo apt autoremove -y

sudo apt install -y git \
  build-essential \
  curl \
  wget \
  python3-pip \
  python3-dev \
  python3-setuptools \
  pipx \
  libfuse2 \
  fonts-firacode \
  vim \
  zsh

install_flatpak
install_dra
install_zsh_plugins
setup_git
setup_pipx

# Cleanup
sudo apt autoremove -y
