{
  lib,
  config,
  pkgs,
  dotfiles-secrets,
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

    age.secrets.vpn = {
      file = "${dotfiles-secrets}/secrets/vpn.age";
      path = "${config.home.homeDirectory}/.vpn";
    };

    age.secrets.openfortivpn = {
      file = "${dotfiles-secrets}/secrets/openfortivpn.age";
      path = "${config.home.homeDirectory}/.config/openfortivpn/config";
    };
  };
}
