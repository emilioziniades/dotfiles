# hadedah

`hadedah` is my personal laptop. It is running MacOS with nix-darwin.
o

## MacOS `nix-darwin` setup

Install `nix` using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer).

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

In addition, there is not great Nix support for GUI applications on MacOS, so I still use `homebrew` for casks only. This is still managed by Nix, but it is necessary to install `homebrew` separately. Instructions below taken from [the homebrew website](https://brew.sh/).

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop 'github:emilioziniades/dotfiles'
```

Clone the dotfiles into `~/dotfiles`.

```
git clone https://github.com/emilioziniades ~/dotfiles
```

Bootstrap [nix-darwin](http://daiderd.com/nix-darwin/#flakes) and set up the system as per the flake. See all options [here](https://daiderd.com/nix-darwin/manual/index.html). This will also install [home-manager](https://nix-community.github.io/home-manager/index.html), which is responsible for managing configuration for applications like `neovim`, `tmux` and `alacritty`. See the seminal [Appendix A](https://nix-community.github.io/home-manager/options.html) for configuration options.

```
nix run nix-darwin -- switch --flake ~/dotfiles
```

From now on, configuration can be updated by runing `darwin-rebuild switch --flake ~/dotfiles`, which I have aliased to simply `switch`.
