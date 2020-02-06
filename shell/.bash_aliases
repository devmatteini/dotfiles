alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .5="cd ../../../.."
alias h="cd ~"

# Git
alias g="git"

# List files
alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -Alh --group-directories-first --color=auto"

# Source
alias src="source"
alias src-alias="source ~/.bash_aliases"
alias va="vim ~/.bash_aliases"

# VS Code
alias code="code ."

# Docker
alias dk="docker"
alias dki="docker images"
alias dkps="docker ps -a"

# Terraform CLI
alias tr="terraform"
alias tri="terraform init"
alias trp="terraform plan"
alias tra="terraform apply"
alias trd="terraform destroy"
alias trv="terraform validate"

# .NET CORE CLI
alias dnb="dotnet build"
alias dnr="dotnet run"
alias dnt="dotnet test"

# Keychron K2 Level Battery
alias k2i="upower --dump | grep keyboard -A 7"
alias k2="upower --dump | grep keyboard -A 7 | grep percentage | sed -e 's/^[ \t]*//'"
