#!/usr/bin/env bash

set -euo pipefail

RESET="\e[0m"
BOLD="\e[1;37m"

REAL_NAME="Cosimo Matteini"
USERNAME="devmatteini"
DEFAULT_HOSTNAME="$USERNAME-ubuntu"
AUTOINSTALL_FILE_PATH="$PWD"/ubuntu-autoinstall.yaml


check_has_installed() {
    if ! command -v "$1" &>/dev/null; then
        echo "Error: $1 is not installed"
        return 1
    fi
}

check_non_empty_string(){
    if [[ -z $1 ]]; then
        echo -e "\nError: $2 cannot be empty"
        return 1
    fi
}

check_has_installed openssl

read -p "Enter hostname (default is $DEFAULT_HOSTNAME): " custom_hostname
hostname=${custom_hostname:-$DEFAULT_HOSTNAME}

read -p "Enter the user password: " -s identity_password_raw
check_non_empty_string "$identity_password_raw" "user password"
# https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html#password
identity_password=$(echo "$identity_password_raw" | openssl passwd -6 -stdin)

echo
read -p "Enter the storage encryption password: " -s storage_password
check_non_empty_string "$storage_password" "storage encryption password"

# https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
cat > "$AUTOINSTALL_FILE_PATH" <<EOL
version: 1
locale: "en_US.UTF-8"
keyboard:
  layout: "us"
source:
  id: "ubuntu-desktop-minimal"
  search_drivers: true
storage:
  layout:
    name: "lvm"
    password: "$storage_password"
identity:
  hostname: "$hostname"
  realname: "$REAL_NAME"
  username: "$USERNAME"
  password: "$identity_password"
codecs:
  install: true
drivers:
  install: true
oem:
  install: "auto"
packages:
  - "git"
timezone: "Europe/Rome"
updates: "all"
shutdown: "reboot"
EOL

echo -e "\nCopy URI for Ubuntu Installer: ${BOLD}file://$AUTOINSTALL_FILE_PATH${RESET}"
