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
    mutableUsers = false;

    users.emilioz = {
      isNormalUser = true;
      home = "/home/emilioz";
      extraGroups = ["wheel"];
      hashedPassword = "$y$j9T$..ZrEKsB5VjpEoeIARpln1$eB8HV5Bo.kQrQtZ88nngNd5i5T4F1F1BuM1ySEIA5J3";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.emilioz = import ./home.nix;
  };

  system.stateVersion = "24.05";
}
