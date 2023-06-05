# dotfiles

:wrench: dotfiles for ubuntu

## Installation

:warning: Backup your current dotfiles, otherwise launching the installation script _will override them_!

```bash
git clone https://github.com/devmatteini/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

The [`bootstrap.sh`](bootstrap.sh) script execute:

1. [bootstrap/file_system.sh](bootstrap/file_system.sh) to create common directories
2. [bootstrap/create_symbolic_links.sh](bootstrap/create_symbolic_links.sh) to create symlinks to home, config and script files
3. [bootstrap/dependencies.sh](bootstrap/dependencies.sh) to install basic dependencies

## Prompt

Currently using [`starship`](https://github.com/starship/starship/) as bash prompt.
You can customize it by editing [`config/starship.toml`](config/starship.toml).

Alternatively you can use [`.bash_prompt`](bash/.bash_prompt) instead of `starship`.

## Terminal Emulator

Currently using [`WezTerm`](https://wezfurlong.org/wezterm/index.html).
You can customize it by editing [`config/wezterm/wezterm.lua`](config/wezterm/wezterm.lua).

Alternatively you can use `gnome-terminal` and load its configuration by running:

```bash
./bootstrap/gnome_terminal.sh gnome-terminal.dconf
```

To export a new configuration follow [this article](https://gist.github.com/devmatteini/968981d95fd203905f7618ce67647e83) instructions.

## Application

If you didn't run the `bootstrap.sh` script, run:

```bash
./bootstrap/dependencies.sh
```

To install application(s):

```bash
./apps/<script>

# List what packages you can install
./apps/tools --list

# Only install some packages
./apps/tools --filter bat,fzf

# Install all packages but exclude some
./apps/tools --exclude aws
```

### :clipboard: List of application script

- browsers (firefox, firefox-dev, chromium)
- docker (docker-ce, docker-compose)
- dotnet (dotnet-sdk-3.1) // OUTDATED
- editors (vscode, rider, vim, intellij-idea)
- fnm (node-v{16,18}, npm, yarn)
- fonts (firacode, firacode nerd font)
- misc (postman, gimp, vlc)
- rust (installation and post install setup)
- tools (fzf, tldr, shellcheck, awscli, bat, ripgrep, ...)

## GRUB Theme

https://github.com/shvchk/poly-dark

![grub-poly-dark](./assets/grub-poly-dark.png)

## Inspired by

- https://github.com/alrra/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/iacoware/dotfiles/
- https://github.com/CoreyMSchafer/dotfiles
