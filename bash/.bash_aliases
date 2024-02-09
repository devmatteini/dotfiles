alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd ~"

# Git
alias g="git"

# List files
alias ll="eza -l --icons=always --group-directories-first"
alias lll="ll --hyperlink"
alias la="eza -al --icons=always --group-directories-first"
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
alias print_path='echo -e ${PATH//:/\\n}'

# apt
alias upgradable="apt list --upgradable"
