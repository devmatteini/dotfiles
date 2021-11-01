# dotfiles

:wrench: dotfiles for ubuntu

## Installation

:warning: Backup your current dotfiles, otherwise launching the installation script _will override them_!

```bash
git clone https://github.com/devmatteini/dotfiles.git && cd dotfiles && source bootstrap.sh
```

The [`bootstrap.sh`](bootstrap.sh) script does:

- create symlinks for bash files inside [`bash/`](bash/) folder
- if using `gnome-terminal`, it will load the [`gnome-terminal.dconf`](gnome-terminal.dconf) configuration file

## Prompt

Currently using [`starship`](https://github.com/starship/starship/) as bash prompt.
You can customize it by editing [`config/starship.toml`](config/starship.toml)

Alternatively you can use [`.bash_prompt`](bash/.bash_prompt) instead of `starship`.

## Application

Install basic dependencies:

```bash
./apps/dependencies.sh
```

If you want to install other application:

```bash
./apps/<script>
```

### :clipboard: List of application script

- browsers (firefox, chromium)
- docker (docker-ce, docker-compose)
- dotnet (dotnet-sdk-3.1)
- editors (vscode, rider, vim)
- nvm (nvm, node-v14)
- snap (postman, gimp, vlc)
- tools (fzf, tldr, shellcheck, awscli, bat, ripgrep)

## Inspired by

- https://github.com/alrra/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/iacoware/dotfiles/
- https://github.com/CoreyMSchafer/dotfiles
