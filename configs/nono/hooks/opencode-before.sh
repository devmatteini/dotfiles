#!/usr/bin/env bash

set -euo pipefail

readonly NONO_PACKAGES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nono/packages"
readonly OPENCODE_HOOK="$NONO_PACKAGES_DIR/nolabs-ai/opencode/bin/ensure-dirs.sh"
readonly DOCKER_HOOK="$HOME/dotfiles/scripts/start-nono-docker-vm"

HOOKS=(
    "$OPENCODE_HOOK"
    "$DOCKER_HOOK"
)

for hook in "${HOOKS[@]}"; do
    if [[ ! -x $hook ]]; then
        echo "opencode-before: hook is not executable: $hook" >&2
        exit 1
    fi

    "$hook"
done
