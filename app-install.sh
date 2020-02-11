#!/bin/bash

# Snap
sudo snap install code --classic
sudo snap install rider --classic
sudo snap install sublime-text --classic
sudo snap install node --classic
sudo snap install postman
sudo snap install gimp
sudo snap install communitheme
sudo snap install chromium
sudo snap install vlc

# Apt

sudo apt update
sudo add-apt-repository universe
sudo apt update

sudo apt install -y build-essential \
curl \
wget \
vim \
git \
python3-dev \
python3-pip \
python3-setuptools \
bat \
libsecret-1-0 \
libsecret-1-dev \
firefox \
gnome-tweaks \

# .NET SDK
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y \
dotnet-sdk-3.1 \
dotnet-sdk-2.2 \

# Docker
sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
stable"

sudo apt-get update
sudo apt-get install -y \
docker-ce \
docker-ce-cli \
containerd.io


# Cleanup
sudo apt autoremove -y

# libsecret build https://askubuntu.com/questions/773455/what-is-the-correct-way-to-use-git-with-gnome-keyring-and-https-repos
(
    cd /usr/share/doc/git/contrib/credential/libsecret
    sudo make
    git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
)

# fzf https://github.com/junegunn/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# thefuck https://github.com/nvbn/thefuck
pip3 install thefuck

# tldr https://github.com/tldr-pages/tldr/
sudo npm install -g tldr

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash