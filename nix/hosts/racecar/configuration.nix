{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "racecar";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  boot.kernelParams = [ "quiet" ];
  boot.plymouth.enable = true;

  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;

  console.useXkbConfig = true;

  hardware.bluetooth.enable = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  users.users.emilioziniades = {
    isNormalUser = true;
    description = "Emilio Ziniades";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "emilioziniades" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  programs.nix-ld.enable = true;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "25.11";
}
