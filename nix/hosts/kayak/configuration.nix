{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    # TODO: Track https://github.com/NixOS/nixpkgs/issues/315574 and remove this
    # inline module when there are updates there.
    (
      {
        lib,
        options,
        ...
      }: {
        options.system.nixos.codeName = lib.mkOption {readOnly = false;};
        config.system.nixos.codeName = let
          codeName = options.system.nixos.codeName.default;
          renames = {"Vicuña" = "Vicuna";};
        in
          renames."${codeName}" or (throw "Unknown `codeName`: ${codeName}");
      }
    )
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kayak";
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

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["emilioz"];
  };

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
        "Hack"
      ];
    })
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    openssl
    openssl_1_1
    xz
    curl
    libgdiplus
  ];

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = false;
  #TODO: don't hardcode
  users.extraGroups.vboxusers.members = ["emilioz"];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "24.05";
}
