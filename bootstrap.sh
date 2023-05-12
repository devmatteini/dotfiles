#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks to your $HOME directory
source bootstrap/create_symbolic_links.sh "$BASEDIR"
