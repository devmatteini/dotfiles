#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks to your $HOME directory
source bin/create_symbolic_links.sh "$BASEDIR"