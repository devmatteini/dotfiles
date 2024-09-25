#!/usr/bin/env bash

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    sudo apt install -y xclip
elif [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    sudo apt install -y wl-clipboard
else
    echo "Unknown XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
    exit 1
fi
