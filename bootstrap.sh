#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$BASEDIR"/bootstrap/file_system.sh
"$BASEDIR"/bootstrap/create_symbolic_links.sh "$BASEDIR"
"$BASEDIR"/bootstrap/dependencies.sh
