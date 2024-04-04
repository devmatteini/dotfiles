# Disable compinit in /etc/zsh/zshrc to improve performance (https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=3401477#gistcomment-3401477)
skip_global_compinit=1

# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export EDITOR="vim"
export DOCKER_BUILDKIT=1
