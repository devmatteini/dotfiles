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
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'

# Keyboard
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'it')]"
gsettings set org.gnome.desktop.input-sources per-window false

# Text Editor
gsettings set org.gnome.TextEditor use-system-font false
gsettings set org.gnome.TextEditor custom-font 'Fira Code 16'
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor indent-style 'space'
gsettings set org.gnome.TextEditor tab-width 2
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor show-map true
gsettings set org.gnome.TextEditor style-scheme 'Yaru-dark'
gsettings set org.gnome.TextEditor style-variant 'dark'

# Weather
gsettings set org.gnome.GWeather4 temperature-unit 'centigrade'

echo -e "${GREEN}Loaded GNOME settings!${RESET}"
