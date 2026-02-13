{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.ez.programs.kubernetes;
in
{
  options.ez.programs.kubernetes.enable = mkEnableOption "kubernetes";

  config = mkIf cfg.enable {
    home.shellAliases = {
      k = "kubectl";
      kubewhere = "kubectx -c; kubens -c";
    };

    home.packages = with pkgs; [
      kubectl
      kubectl-validate
      kubectx
      kubernetes-helm
      k9s
      argocd
      rancher
    ];

    xdg.configFile."k9s/skins" = {
      source = "${inputs.catppuccin-k9s}/dist";
      recursive = true;
    };

    xdg.configFile."k9s/config.yaml".text = lib.generators.toYAML { } {
      k9s.ui.skin = "catppuccin-mocha";
    };
  };
}
