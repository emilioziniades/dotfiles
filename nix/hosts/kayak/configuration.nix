{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kayak";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  hardware.graphics.enable = true;

  console.useXkbConfig = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Fingerprint login (see https://wiki.nixos.org/wiki/Fingerprint_scanner)
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.cloudflare-warp.enable = true;

  age.identityPaths = [ "/home/emilioziniades/.ssh/id_ed25519" ];
  age.secrets.hosts.file = "${inputs.dotfiles-secrets}/secrets/hosts.age";
  # EW! `networking.hostFile` doesn't work because the module tries to concatenate the files at build time,
  # before the secret has been decrypted. So I have to use this dirty-feeling activation script
  system.activationScripts.hostFile = ''
    cp /etc/hosts /etc/hosts.backup
    cat ${config.age.secrets.hosts.path} >> /etc/hosts.backup
    rm /etc/hosts
    mv /etc/hosts.backup /etc/hosts
  '';

  users.users.emilioziniades = {
    isNormalUser = true;
    description = "Emilio Ziniades";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
    ];
    shell = pkgs.zsh;
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

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = [ "emilioziniades" ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "25.11";
}
