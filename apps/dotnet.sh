#!/bin/bash

sudo apt update
sudo add-apt-repository universe

sudo apt update
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y dotnet-sdk-3.1 dotnet-sdk-2.2

# Cleanup
rm packages-microsoft-prod.deb