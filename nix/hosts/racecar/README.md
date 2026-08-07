# racecar

`racecar` is my personl NixOS desktop.

## NixOS setup

This setup uses disko for disk configuration.

Boot up into a nixos-minimal installer.

Connect to a wifi with `nmcli dev wifi connect SSID --ask`.

Enter a development shell with the tools necessary to bootstrap the flake.

```
nix develop --extra-experimental-features "nix-command flakes" 'github:emilioziniades/dotfiles'

```

```
sudo nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake 'github:emilioziniades/dotfiles#racecar' --write-efi-boot-entries
```

# BELOW IS COPY - DELETE WHEN DONE

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
