#!/usr/bin/env bash

# GitHub: https://github.com/Schniz/fnm

INSTALL_DIR="$HOME/.local/apps/fnm"
BASH_COMPLETIONS="$HOME/.local/share/bash-completion/completions"

curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$INSTALL_DIR" --skip-shell

ln -sf "$INSTALL_DIR/fnm" "$HOME/.local/bin/fnm"

# Install node versions
fnm install --corepack-enabled 18
fnm install --corepack-enabled 20

fnm completions --shell bash > "$BASH_COMPLETIONS/fnm"

# *************** NPM/YARN ***************

# npm bash completions
npm completion > "$BASH_COMPLETIONS/npm"

# yarn bash completions
curl -o "$HOME/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
