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
You can customize it by editing [`config/zsh`](config/zsh/) files.

Alternatively you can use [`bash`](bash/).

## Prompt

Currently using [`starship`](https://github.com/starship/starship/).
You can customize it by editing [`config/starship.toml`](config/starship.toml).

By default if starship is not installed basic fallback prompt is available for both `bash` and `zsh`.

## Terminal Emulator

Currently using [`WezTerm`](https://wezfurlong.org/wezterm/index.html).
You can customize it by editing [`config/wezterm/wezterm.lua`](config/wezterm/wezterm.lua).

Alternatively you can use `gnome-terminal` and load its configuration by running:

```bash
./bootstrap/gnome_terminal.sh gnome-terminal.dconf
```

To export a new configuration follow [this article](https://gist.github.com/devmatteini/968981d95fd203905f7618ce67647e83) instructions.

## Applications

If you didn't run the `bootstrap.sh` script, run:

```bash
./bootstrap/file_system.sh
./bootstrap/dependencies.sh
```

To install application you can find scripts in [`apps`](apps/).

### Simple bash scripts

```bash
./apps/<script>.sh
```

### Advanced installers

Python scripts to install multiple apps with a convenient `cli` wrapper:

```bash
./apps/<script> --help

# List what packages you can install
./apps/tools --list

# Only install some packages
./apps/tools --filter bat,fzf

# Install all packages but exclude some
./apps/tools --exclude aws
```

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
