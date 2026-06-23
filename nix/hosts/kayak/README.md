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
On a fresh machine `~/.ssh/config.work` doesn't exist yet, so the `work-git` host alias can't resolve.
Supply the real hostname for this one build via `GIT_SSH_COMMAND`.
After the first switch, agenix manages `~/.ssh/config.work`.

```
GIT_SSH_COMMAND='ssh -o HostName=<work-git-hostname>' nixos-rebuild switch --flake ~/dotfiles#kayak --sudo
```

From then on, you can run `just switch-nixos` instead.
