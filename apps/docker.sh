#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# User group for docker
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker

# Install docker-compose
pip3 install docker-compose --user