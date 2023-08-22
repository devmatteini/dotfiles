#!/usr/bin/env bash

mkcd(){
    mkdir -p "$1" && cd "$_" || return 1
}

change-aws-profile(){
    local profile
    profile=$(aws configure list-profiles | fzf --cycle --layout=reverse)
    if [[ -z $profile ]]; then
        echo "Nothing selected"
        return 0
    fi
    export AWS_PROFILE="$profile"
}

gen_uuid(){
    UUID=$(cat /proc/sys/kernel/random/uuid)
    IS_COPIED="false"
    
    if [[ $XDG_SESSION_TYPE == "x11" ]]; then
        echo "$UUID" | xclip -r -sel clip
        IS_COPIED="true"
    elif [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        wl-copy "$UUID"
        IS_COPIED="true"
    fi

    if [[ $IS_COPIED == "true" ]]; then
        echo "$UUID copied to clipboard!"
    else
        echo "$UUID"
    fi
}
