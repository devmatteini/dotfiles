# dotfiles

:wrench: dotfiles for ubuntu

## Installation

:warning: Backup your current dotfiles, otherwise launching the installation script _will override them_!

```bash
git clone https://github.com/devmatteini/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

The [`bootstrap.sh`](bootstrap.sh) script execute:

1. [bootstrap/file_system.sh](bootstrap/file_system.sh) to create common directories
2. [bootstrap/create_symbolic_links.sh](bootstrap/create_symbolic_links.sh) to create symlinks to home and config files
3. [bootstrap/dependencies.sh](bootstrap/dependencies.sh) to install basic dependencies

## Shell

Currently using [`zsh`](https://www.zsh.org/).
You can customize it by editing [`configs/zsh`](configs/zsh/) files.

Alternatively you can use [`configs/bash`](configs/bash/).

## Prompt

Currently using [`starship`](https://github.com/starship/starship/).
You can customize it by editing [`configs/starship.toml`](configs/starship.toml).

By default if starship is not installed basic fallback prompt is available for both `bash` and `zsh`.

## Terminal Emulator

Currently using [`WezTerm`](https://wezfurlong.org/wezterm/index.html).
You can customize it by editing [`configs/wezterm/wezterm.lua`](configs/wezterm/wezterm.lua).

Alternatively you can use `gnome-terminal` and load its configuration by running:

```bash
./packages/gnome-terminal configs/gnome-terminal.dconf
```

To export a new configuration follow [this article](https://gist.github.com/devmatteini/968981d95fd203905f7618ce67647e83) instructions.

## Packages

If you didn't run the `bootstrap.sh` script, run:

```bash
./bootstrap/file_system.sh
./bootstrap/dependencies.sh
```

To install packages you can find scripts in [`packages/`](packages/).

## GRUB Theme

https://github.com/shvchk/poly-dark

![grub-poly-dark](./assets/grub-poly-dark.png)

## Inspired by

- https://github.com/alrra/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/iacoware/dotfiles/
- https://github.com/CoreyMSchafer/dotfiles
- https://github.com/mrnugget/dotfiles
- https://github.com/LukeSmithxyz/voidrice
- https://github.com/Phantas0s/.dotfiles
- https://github.com/basecamp/omakub
