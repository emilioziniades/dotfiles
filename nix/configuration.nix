{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.options = "caps:backspace";
  };

  console.useXkbConfig = true;

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  users.users.emilioz = {
    isNormalUser = true;
    description = "Emilio Ziniades";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
      "openssl-1.1.1w"
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
    # CLM
    trusted-cert = d85894186688b5842459ae4833f7127237d0a4895ddb984cdf349c149707b6fe
    # ISD
    trusted-cert = 0fa7b4d0572540093833a443e739a316e29d586b0332bd7de02dddc6e00735da
  '';

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
    openssl_1_1
    xz
    curl
  ];

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
