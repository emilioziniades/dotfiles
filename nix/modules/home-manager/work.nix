{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.ez.work;
  vt-cli = pkgs.callPackage ../../pkgs/vt-cli/package.nix {pythonPackages = pkgs.python3.pkgs;};
  vpn = pkgs.callPackage ../../pkgs/vpn/package.nix {};
in {
  options.ez.work = {
    enable = mkEnableOption "Work development tools";
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
      kubernetes-helm
      k9s
      intune-portal
    ];

    age.secrets.vpn = {
      file = "${inputs.dotfiles-secrets}/secrets/vpn.age";
      path = "${config.home.homeDirectory}/.vpn";
    };

    age.secrets.openfortivpn = {
      file = "${inputs.dotfiles-secrets}/secrets/openfortivpn.age";
      path = "${config.xdg.configHome}/openfortivpn/config";
    };

    age.secrets.netrc = {
      file = "${inputs.dotfiles-secrets}/secrets/netrc.age";
      path = "${config.home.homeDirectory}/.netrc";
    };

    age.secrets.gitconfig = {
      file = "${inputs.dotfiles-secrets}/secrets/gitconfig.age";
      path = "${config.xdg.configHome}/git/config.work";
    };
  };
}
