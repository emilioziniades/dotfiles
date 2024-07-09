# The VM is set up with the following details:
# - 4GB RAM
# - 2 CPU
# - 64GB disk space
# - EFI enabled

# setup script to run before doing "nixos-install"
# remember to run this as sudo

echo "setting up disk partitions"
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -1GiB
parted /dev/sda -- mkpart primary linux-swap -1GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

echo "setting up filesystems"
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

echo "preparing for install"
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
# nixos-generate-config --root /mnt
# vim /mnt/etc/nixos/configuration.nix
# set the below inside the configuration.nix
# make sure that `boot.loader.grub.*` are all commented out
## boot.loader.systemd-boot.enable = true;
## boot.loader.efi.canTouchEfiVariables = true;
## boot.loader.timeout = 2;
## nix = {
##    package = pkgs.nixUnstable;
##    extraOptions = "experimental-features = nix-command flakes";
## };
## virtualisation.virtualbox.guest.enable = true;
# nixos-install # now, wait a while
