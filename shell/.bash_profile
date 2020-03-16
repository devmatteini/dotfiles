# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load the shell dotfiles
for file in ~/.{bash_aliases,bash_exports,bash_options,bash_prompt,bash_functions,bash.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for many Bash commands
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Add tab completion for git alias "g"
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
    __git_complete g _git
fi

# Source fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add tab completion for aws-cli
if [ -f /home/$USER/.local/bin/aws_bash_completer  ];then
    source /home/$USER/.local/bin/aws_bash_completer
fi

# Enable docker buildkit
export DOCKER_BUILDKIT=1
