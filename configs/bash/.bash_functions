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

typetest(){
    if [[ -e package-lock.json ]]; then
        npm run typecheck && npm run test
    elif [[ -e yarn.lock ]]; then
        if [[ -n $1 ]]; then
            yarn workspace "$1" typecheck && yarn workspace "$1" test
        else
            yarn typecheck && yarn test
        fi
    elif [[ -e pnpm-lock.yaml ]]; then
        pnpm typecheck && pnpm test
    else
        echo "Cannot recognize node package manager (npm or yarn)"
        return 1
    fi
}

gh_clear_cache(){
    PATTERN_OR_ALL="$1"
    gh cache list | rg "$PATTERN_OR_ALL" | awk '{print $2}' | xargs -I {} gh cache delete {}
}

vercel_delete_previews(){
    npx vercel ls --environment preview --no-color 2>/dev/null | xargs -I {} npx vercel rm --yes {}
}
