#!/bin/bash

# Check out this guide:
# https://askubuntu.com/questions/773455/what-is-the-correct-way-to-use-git-with-gnome-keyring-and-https-repos

sudo apt install -y libsecret-1-0 libsecret-1-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret

# Install syntax-highlighting pager and diff output
# https://github.com/dandavison/delta
curl -fsSL -o git-delta.deb \
    https://github.com/dandavison/delta/releases/download/0.9.2/git-delta_0.9.2_amd64.deb
sudo dpkg -i ./git-delta.deb
rm ./git-delta.deb