# dotfiles

:wrench: dotfiles for ubuntu

## Installation

:warning: Backup your current dotfiles, otherwise launching the installation script _will override them_!

```bash
git clone https://github.com/devmatteini/dotfiles.git && cd dotfiles && source bootstrap.sh
```

## Application

Install basic dependencies:

```bash
source apps/dependencies.sh
```

If you want to install other application:

```bash
source apps/<name_of_the_file.sh>
```

### :clipboard: List of application script

- browsers (firefox, chromium)
- docker (docker-ce, docker-compose)
- dotnet (dotnet-sdk-3.1, dotnet-sdk-2.2)
- editors (vscode, rider, vim)
- nvm (nvm, node-v12)
- snap (postman, gimp, communitheme, vlc)
- tools (fzf, thefuck, tldr, joplin, awscli)

## Inspired by

- https://github.com/alrra/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/iacoware/dotfiles/
- https://github.com/CoreyMSchafer/dotfiles
