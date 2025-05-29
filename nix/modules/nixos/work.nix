{pkgs, ...}
: {
  services.intune.enable = true;

  environment.systemPackages = with pkgs; [
    intune-portal
  ];
}
