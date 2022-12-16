#!/usr/bin/env bash

# This script install firefox as .deb package from mozilla ppa.
# The problem with the snap version was making gnome extensions work! 
# Source: https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04

sudo snap remove --purge firefox

sudo add-apt-repository -y ppa:mozillateam/ppa

# Alter the Firefox package priority to ensure the PPA/deb/apt version of Firefox is preferred
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

# Make future Firefox upgrades installed automatically
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

sudo apt install firefox
