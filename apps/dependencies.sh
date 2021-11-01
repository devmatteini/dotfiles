#!/bin/bash

sudo apt update
sudo add-apt-repository universe
sudo apt update

sudo apt install -y build-essential \
curl \
wget \
git \
python3-pip \
python3-dev \
python3-setuptools

# Cleanup
sudo apt autoremove
