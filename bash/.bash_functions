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
