# dotfiles

**NOTE: I am in the process of migrating all my dotfiles over to nix.**

## MacOS `nix-darwin` setup

Fetch these dotfiles. All this config assumes that the dotfiles are cloned to `~/dotfiles`.

```
cd && git clone https://github.com/emilioziniades/dotfiles && cd dotfiles
```

Install nix using the [determinate systems installer](https://github.com/DeterminateSystems/nix-installer).

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Install [nix-darwin](http://daiderd.com/nix-darwin/). See all options [here](https://daiderd.com/nix-darwin/manual/index.html).

```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
```

Bootstrap nix-darwin flake. This will install [home-manager](https://nix-community.github.io/home-manager/index.html), which is responsible for managing configuration for applications like `neovim`, `tmux` and `alacritty`.

```
nix build ~/dotfiles\#darwinConfigurations.Emilios-MacBook-Pro.system
./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin
```

In addition, there is not great Nix support for GUI applications on MacOS, so I still use `homebrew` for casks only. This is still managed by Nix, but it is necessary to install `homebrew` separately. Instructions below taken from [the homebrew website](https://brew.sh/).

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

From now on, configuration can be updated by runing `darwin-rebuild switch --flake ~/dotfiles`, which I have aliased to simply `switch`.

# Ubuntu/Pop_OS!/NixOS setup

_TODO_
