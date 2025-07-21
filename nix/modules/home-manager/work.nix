{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.ez.work;
in {
  options.ez.work = {
    enable = mkEnableOption "Work development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mongosh
      mongodb-tools
      awscli2
      argocd
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
