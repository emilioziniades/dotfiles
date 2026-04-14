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
  };
}
