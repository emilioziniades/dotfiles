{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ez.vt;
  vt-cli = pkgs.callPackage ../../pkgs/vt-cli/package.nix {pythonPackages = pkgs.python3.pkgs;};
  vpn = pkgs.callPackage ../../pkgs/vpn/package.nix {};
in {
  options.ez.vt = {
    enable = mkEnableOption "VT development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vt-cli
      vpn
      mongosh
      awscli2
      kubectl
    ];

    home.sessionVariables.VPN_CONFIG_FILE = config.age.secrets.vpn-config.path;
  };
}
