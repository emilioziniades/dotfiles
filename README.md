# dotfiles

These dotfiles use [Nix](https://nixos.org/) to manage configuration and development environments, for both my personal MacOS system and my work Debian system.
I have also used NixOS in the past so there are instructions for that too.

Currently, my workflow revolves around a combination of [WezTerm](https://wezfurlong.org/wezterm/index.html), [Tmux](https://github.com/tmux/tmux) and [Neovim](https://neovim.io/).

## MacOS `nix-darwin` setup

Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop 'github:emilioziniades/dotfiles'
```

Clone the dotfiles into `~/dotfiles`.

```
git clone https://github.com/emilioziniades ~/dotfiles
```

Install `nix` using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer).

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

In addition, there is not great Nix support for GUI applications on MacOS, so I still use `homebrew` for casks only. This is still managed by Nix, but it is necessary to install `homebrew` separately. Instructions below taken from [the homebrew website](https://brew.sh/).

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Bootstrap [nix-darwin](http://daiderd.com/nix-darwin/#flakes) and set up the system as per the flake. See all options [here](https://daiderd.com/nix-darwin/manual/index.html). This will also install [home-manager](https://nix-community.github.io/home-manager/index.html), which is responsible for managing configuration for applications like `neovim`, `tmux` and `alacritty`. See the seminal [Appendix A](https://nix-community.github.io/home-manager/options.html) for configuration options.

```
nix run nix-darwin -- switch --flake ~/dotfiles
```

From now on, configuration can be updated by runing `darwin-rebuild switch --flake ~/dotfiles`, which I have aliased to simply `switch`.

## Debian setup (home-manager standalone setup)

There are a bunch of manual steps required which wouldn't be necessary on a NixOS machine.
This is because the perfect, declarative world of NixOS breaks when you try use nix on non-NixOS Linux operating systems like Debian.
It's sad, but necessary for $WORK.

### Begrudgingly do manual setup

#### Add myself to sudo.

```
su -
visudo
```

And add the following line below `root ALL=...`.

```
emilioz ALL=(ALL:ALL) ALL
```

#### Install curl

```
sudo apt install curl
```

#### Install nix using determinate systems installer

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### Install wezterm

See instructions [here](https://wezfurlong.org/wezterm/install/linux.html).

```
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
```

Now, you have done the manual gruntwork, and hopefully you have done this with resentment, and yearning for a NixOS distribution.

### Bootstrap home-manager

Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop 'github:emilioziniades/dotfiles'
```

Clone the dotfiles into `~/dotfiles`.

```
git clone https://github.com/emilioziniades ~/dotfiles
```

Build the flake-based configuration.

```
nix run nixpkgs#home-manager -- switch --flake ~/dotfiles
```

From then on, you can run `switch`, an alias for the above.

### More manual setup

#### Set zsh as default shell

Add nix zsh to /etc/shells.

```
which zsh | sudo tee /etc/shells
```

Set that to be your default shell.

```
chsh -s $(which zsh)
```

## NixOS setup

Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop 'github:emilioziniades/dotfiles'
```

Clone the dotfiles into `~/dotfiles`.

```
git clone https://github.com/emilioziniades ~/dotfiles
```

Save a freshly generated version of `hardware-configuration.nix` into this repository. Commit the changes.

```
nixos-generate-config --dir ~/dotfiles/nix
```

Then, build the flake-based configuration.

```
sudo -u $USER nixos-rebuild switch --flake ~/dotfiles
```

From then on, you can run `switch`, an alias for the above.
