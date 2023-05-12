#!/usr/bin/env bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$BASEDIR"/bootstrap/create_symbolic_links.sh "$BASEDIR"
"$BASEDIR"/bootstrap/dependencies.sh
