{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ez.velocity-trade;
  vt-cli = pkgs.callPackage ../../pkgs/vt-cli/package.nix {pythonPackages = pkgs.python3.pkgs;};
  vpn = pkgs.callPackage ../../pkgs/vpn/package.nix {};
in {
  options.ez.velocity-trade = {
    enable = mkEnableOption "Velocity Trade development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vt-cli
      vpn
      mongosh
      awscli2
      kubectl
    ];
  };
}
