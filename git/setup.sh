#!/usr/bin/env bash

# Check out this guide:
# https://askubuntu.com/questions/773455/what-is-the-correct-way-to-use-git-with-gnome-keyring-and-https-repos

sudo apt install -y libsecret-1-0 libsecret-1-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret

# Install syntax-highlighting pager and diff output
# https://github.com/dandavison/delta
sudo dra download -i -s "git-delta_{tag}_amd64.deb" dandavison/delta
