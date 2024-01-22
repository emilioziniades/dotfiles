{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  users.users.emilioz = {
    isNormalUser = true;
    description = "Emilio Ziniades";
    extraGroups = ["networkmanager" "wheel" "audio"];
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
    pulseaudio = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment.etc."openfortivpn/config".text = ''
    trusted-cert = d85894186688b5842459ae4833f7127237d0a4895ddb984cdf349c149707b6fe
  '';

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
  ];

  system.stateVersion = "23.11";
}
