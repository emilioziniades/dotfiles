{
  imports = [
    ./disko-configuration.nix
  ];

  networking.hostName = "oxo";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  nix.extraOptions = "experimental-features = nix-command flakes";

  virtualisation.virtualbox.guest.enable = true;

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  users = {
    users.emilioz = {
      isNormalUser = true;
      home = "/home/emilioz";
      extraGroups = ["wheel"];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.emilioz = import ./home.nix;
  };

  system.stateVersion = "24.05";
}
