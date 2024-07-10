# oxo

`oxo` is the name for my virtualbox config, which is useful for experimenting with nixos features.

## Download ISO

Download the minimal nixos installer from <https://nixos.org/download/>.

## Setup virtual machine

Create a new virtual machine.
These parameters seem to work well.

```
Base Memory: 8192MB
Processors: 4
Enable EFI: Yes
Virtual Hard Disk Size: 16GB
```

After creation go to `Settings > Network > Advanced > Port Forwarding` and add an entry for TCP, host port 2222, guest port 22.
This will enable SSH access once the OS is installed.

## Install

Installation is done using [`disko`](https://github.com/nix-community/disko).

```bash
sudo nix --extra-experimental-features "nix-command flakes" run "github:nix-community/disko#disko-install" -- --flake "github:emilioziniades/dotfiles#oxo" --disk main /dev/sda --write-efi-boot-entries
```

This looks a little unwieldy, so here's the command again but explained with comments.

```bash
sudo # we need to run as root
nix  # invoke nix
--extra-experimental-features "nix-command flakes" # enable flakes and commands like `nix run` which are still considered "experimental"
run # don't loose track here, we are just doing `sudo nix run`
"github:nix-community/disko#disko-install" # run the disko-install flake output from the disko repository
-- # everything after this pair of dashes will be passed to the disko-install script
--flake "github:emilioziniades/dotfiles#oxo" # this is the flake we will use to install the system
--disk main /dev/sda # this is the disk and device disko should be formatting and partitioning
--write-efi-boot-entries # persist the boot entry
```
