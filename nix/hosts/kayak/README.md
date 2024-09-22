# kayak

`kayak` is my NixOS work machine.

## NixOS setup

These steps assume you have installed NixOS fresh from an ISO, followed the graphical installer and restarted the machine.
Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop --extra-experimental-features "nix-command flakes" 'github:emilioziniades/dotfiles'

```

Clone these dotfiles into `~/dotfiles`.

```
git clone https://github.com/emilioziniades/dotfiles ~/dotfiles
```

Save a freshly generated version of `hardware-configuration.nix` into this repository. Commit the changes.

```
nixos-generate-config --dir ~/dotfiles/nix/hosts/kayak
```

Then, build the flake-based configuration.

```
sudo nixos-rebuild switch --flake ~/dotfiles#kayak
```

From then on, you can run `just switch-nixos` instead.
