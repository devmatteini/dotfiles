#!/usr/bin/env bash

mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged

# Install vim-plug (https://github.com/junegunn/vim-plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins (https://github.com/junegunn/vim-plug/issues/675#issuecomment-328157169)
vim +'PlugInstall --sync' +qa
