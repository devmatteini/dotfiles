#!/usr/bin/env bash

# workspace.sh
# ----------------------------------------
# Common utilities to write scripts to setup workspaces

# Run a command inside a pane 
# DOCS: https://github.com/wez/wezterm/discussions/2202#discussioncomment-3052321 
run_command() {
    local pane_id
    local command_to_run
    pane_id="$1"
    command_to_run="$2"

    if [[ -z "$pane_id" ]]; then
        echo "run_command: Missing pane-id"
        return 1
    fi
    if [[ -z "$command_to_run" ]];then
        echo "Passed empty command. Skipping"
        return 0
    fi

    echo -e "$command_to_run\n" | wezterm cli send-text --no-paste --pane-id "$pane_id"
}
