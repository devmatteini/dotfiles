#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks to your $HOME directory
source bin/create_symbolic_links.sh "$BASEDIR"

# Load gnome-terminal config file, if using gnome-terminal
terminal=$(< "/proc/${1:-$PPID}/comm")
if [ "$terminal" == "gnome-terminal-" ]; then
    source bin/gnome_terminal.sh gnome-terminal.dconf
fi