#!/usr/bin/env bash

set -euo pipefail

RESET="\e[0m"
GREEN="\e[1;32m"

gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface toolkit-accessibility false

# Power
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false

# Appearance
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Mouse & Touchpad
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.44852941176470584

# Keyboard
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'it')]"
gsettings set org.gnome.desktop.input-sources per-window false

echo -e "${GREEN}Loaded GNOME settings!${RESET}"
