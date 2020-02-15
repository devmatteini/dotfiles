#!/bin/bash

sudo apt update
sudo add-apt-repository universe
sudo apt update

sudo apt install -y build-essential \
curl \
wget \
vim \
git \
python3-pip \
python3-dev \
python3-setuptools \
libsecret-1-0 \
libsecret-1-dev \
gnome-tweaks \

# Cleanup
sudo apt autoremove