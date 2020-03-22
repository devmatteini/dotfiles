#!/bin/bash

sudo apt update
sudo apt install -y curl apt-transport-https ca-certificates software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y docker-ce

# User group for docker
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker

# Install docker-compose
pip3 install docker-compose --user