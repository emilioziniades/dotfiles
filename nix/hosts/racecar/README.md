# racecar

`racecar` is my personl NixOS desktop.

## NixOS setup

### Prepare for first build

This setup uses [disko](https://github.com/nix-community/disko) for disk configuration.

Boot up into a nixos-minimal installer.

Connect to wifi.

```
nmcli dev wifi connect SSID --ask
```

Grow the in-memory `/nix/.rw-store` so that there is enough space to build the full initial closure.

```
sudo mount -o remount,size=12G /nix/.rw-store
```

### Build the initial system

Build the initial system closure and format the disks with `disko-install`, which combines `nixos-install` with `disko`.

## First time install

Clone these dotfiles and save `hardware-configuration.nix` without filesystems into `./nix/hosts/racecar/hardware-configuration.nix`.

```
git clone https://github.com/emilioziniades/dotfiles
cd dotfiles
nixos-generate-config --no-filesystems --show-hardware-config > ./nix/hosts/racecar/hardware-configuration.nix
git add ./nix/hosts/racecar/hardware-configuration.nix
```

Rebuild the intial system closure from the local flake.

```
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- --flake .#racecar --write-efi-boot-entries --disk main /dev/sda
```

After the system has built, remember to generate `hardware-configuration.nix` again and check it into this repository.

## Rebuilds

Rebuild the system using the remote flake at `github:emilioziniades/dotfiles` which already has `hardware-configuration.nix`.

```
sudo nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake 'github:emilioziniades/dotfiles#racecar' --write-efi-boot-entries --disk main /dev/sda
```

### Post-install

Reboot, pull out the USB with the installer and change the boot order in the BIOS if necessary.

```
sudo reboot
```

Change the password for `emilioziniades`

```
sudo passwd emilioziniades
```
