#!/usr/bin/env bash

# GitHub: https://github.com/Schniz/fnm

INSTALL_DIR="$HOME/.local/apps/fnm"

curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$INSTALL_DIR" --skip-shell

ln -sf "$INSTALL_DIR/fnm" "$HOME/.local/bin/fnm"

# Install node versions
fnm install 16
fnm install 18

fnm completions --shell bash > "$HOME"/.local/share/bash-completion/completions/fnm

# *************** NPM/YARN ***************

# Setup npm
npm completion > "$HOME"/.local/share/bash-completion/completions/npm

# Setup yarn https://yarnpkg.com/getting-started/install#nodejs-1610
corepack enable