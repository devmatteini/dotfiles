#!/usr/bin/env bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source "$HOME"/.cargo/env

# Setup bash completions
COMPLETION_DIR="$HOME"/.local/share/bash-completion/completions

rustup completions bash rustup > "$COMPLETION_DIR"/rustup
rustup completions bash cargo > "$COMPLETION_DIR"/cargo
