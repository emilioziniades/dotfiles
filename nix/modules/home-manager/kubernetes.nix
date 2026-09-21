{
  pkgs,
  lib,
  config,
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
      k = "kubecolor";
      kubewhere = "kubectx -c; kubens -c";
    };

    home.packages = with pkgs; [
      kubectl
      kubectl-validate
      kubecolor
      kubectx
      kube-capacity
      kubernetes-helm
      k9s
      argocd
      rancher
    ];
  };
}
