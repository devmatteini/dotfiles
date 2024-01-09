alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd ~"

# Git
alias g="git"

# List files
alias ll="ls -lh --group-directories-first --color=auto"
alias la="ls -Alh --group-directories-first --color=auto"
alias tree="erd -H -I --layout inverted"
alias treeh="erd -H -I --layout inverted --hidden"

# Docker
alias dk="docker"
alias dki="docker images"
alias dkps="docker ps -a"

# Terraform CLI
alias trp="terraform plan"
alias tra="terraform apply"

# .NET CORE CLI
alias dnt="dotnet test"

# Misc
alias utc="date --iso-8601"

# apt
alias upgradable="apt list --upgradable"
