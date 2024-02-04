typeset -U path PATH
autoload -U colors && colors

# --------------------
# PATH
# --------------------

path=(
    "$HOME/.local/bin"
    "$HOME/dotfiles/scripts"
    "$HOME/.cargo/bin"
    "$HOME/.local/share/mise/shims"
    $path
)
export PATH

# --------------------
# Aliases, functions and private configs
# --------------------

for file in ~/.{zsh_aliases,zsh_functions,zsh.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# --------------------
# Command completion
# --------------------

autoload -Uz compinit
compinit
_comp_options+=(globdots) # Include hidden files

setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

zstyle ':completion:*' menu select
# Use case-insensitive TAB autocompletion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --------------------
# History
# --------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY     # Immediately append to history file
setopt EXTENDED_HISTORY       # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.

# --------------------
# Key Bindings
# --------------------

# Mapping CTRl + [left|right] arrow to move between words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# --------------------
# Tools & Environment variables
# --------------------

export EDITOR="vim"
export DOCKER_BUILDKIT=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --------------------
# Prompt & History search
# --------------------

if command -v starship > /dev/null; then
    eval "$(starship init zsh)"
else
    orange=$(tput setaf 166)
    white=$(tput setaf 15)
    yellow=$(tput setaf 228)
    green=$(tput setaf 71)
    reset=$(tput sgr0)
    PS1="%B$orange%n$white@$yellow%m ${white}in $green%~
$reset$ "
fi

if command -v atuin > /dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
