# kayak

`kayak` is my work machine. It is currently running Debian, but I am planning to switch back to NixOS pending some testing of a monitoring tool used at $WORK.

For now I'll keep both sets of setup instructions below.

## Debian standalone `home-manager` setup

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
