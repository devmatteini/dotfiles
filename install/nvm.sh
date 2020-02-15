#!/bin/bash

export PROFILE=~/.bash_profile
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

# Install node latest v12.x.x
source ~/.bash_profile
nvm install 12
