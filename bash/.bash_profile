# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/dotfiles/scripts" ] ; then
    PATH="$HOME/dotfiles/scripts:$PATH"
fi

# Add cargo to path
[ -d "$HOME"/.cargo/bin ] && PATH="$HOME/.cargo/bin:$PATH"

# Load the shell dotfiles
for file in ~/.{bash_exports,bash_aliases,bash_options,bash_functions,bash.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for many Bash commands
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Add tab completion for git alias "g" (https://askubuntu.com/a/642778)
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
    __git_complete g __git_main
fi

# Source fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source fnm (node version manger)
if command -v fnm > /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

if command -v direnv > /dev/null; then
    eval "$(direnv hook bash)"
fi

# Add autocomplete for pipx
if command -v pipx > /dev/null; then
    if command -v register-python-argcomplete3 > /dev/null; then
        eval "$(register-python-argcomplete3 pipx)"
    elif command -v register-python-argcomplete > /dev/null; then
        eval "$(register-python-argcomplete pipx)"
    fi
fi

# Haskell (https://www.haskell.org/ghcup/)
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env


# NOTE: the right order must be (if atuin if eval'd before starship it will show the job module):
# 1. bash-preexec
# 2. starship
# 3. atuin

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

if command -v starship > /dev/null; then
    eval "$(starship init bash)"
else
    source ~/.bash_prompt
fi

if command -v atuin > /dev/null; then
    eval "$(atuin init bash --disable-up-arrow)"
fi
