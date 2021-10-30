#!/bin/bash

# fzf https://github.com/junegunn/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# https://github.com/koalaman/shellcheck
sudo apt install shellcheck

# thefuck https://github.com/nvbn/thefuck
# pip3 install thefuck

# tldr https://github.com/tldr-pages/tldr/
npm install -g tldr

# Joplin https://github.com/laurent22/joplin
# wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

# AWS cli
pip3 install awscli --upgrade --user

# https://github.com/sharkdp/bat
curl -fsSL -o bat.deb \
    https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb
sudo dpkg -i ./bat.deb
rm ./bat.deb