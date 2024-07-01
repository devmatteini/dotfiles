#!/usr/bin/env bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source "$HOME"/.cargo/env

BASH_COMPLETION_DIR="$HOME"/.local/share/bash-completion/completions
ZSH_COMPLETION_DIR="$HOME/.local/share/zsh-completion"

# bash
rustup completions bash rustup > "$BASH_COMPLETION_DIR"/rustup
rustup completions bash cargo > "$BASH_COMPLETION_DIR"/cargo

# zsh
rustup completions zsh rustup > "$ZSH_COMPLETION_DIR"/_rustup
rustup completions zsh cargo > "$ZSH_COMPLETION_DIR"/_cargo
