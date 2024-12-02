{
  lib,
  config,
  pkgs,
  inputs,
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
      mongodb-tools
      awscli2
      kubectl
      kubectx
    ];

    age.secrets.vpn = {
      file = "${inputs.dotfiles-secrets}/secrets/vpn.age";
      path = "${config.home.homeDirectory}/.vpn";
    };

    age.secrets.openfortivpn = {
      file = "${inputs.dotfiles-secrets}/secrets/openfortivpn.age";
      path = "${config.xdg.configHome}/openfortivpn/config";
    };

    # TODO: uncomment once git+curl issues have made its way to nixos-unstable
    # age.secrets.netrc = {
    #   file = "${inputs.dotfiles-secrets}/secrets/netrc.age";
    #   path = "${config.home.homeDirectory}/.netrc";
    # };
  };
}
