{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/sentinelone.nix
    ../../modules/nixos/work.nix
    ../../modules/nixos/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "VTFS-LTP-24";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";

  services.xserver.enable = true;

  services.desktopManager.gnome.enable = true;

  services.displayManager = {
    gdm.enable = true;
    gdm.wayland = false;
  };

  console.useXkbConfig = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  users.users.emilioz = {
    isNormalUser = true;
    description = "Emilio Ziniades";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    shell = pkgs.zsh;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["emilioz"];
  };

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
    xz
    curl
    libgdiplus
  ];

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = ["emilioz"];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "24.05";
}
