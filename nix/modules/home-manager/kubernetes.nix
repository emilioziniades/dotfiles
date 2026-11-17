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
      k = "kubectl";
      kubewhere = "kubectx -c; kubens -c";
    };

    home.packages = with pkgs; [
      kubectl
      # TODO: Use Go 1.26 until https://github.com/NixOS/nixpkgs/pull/589201 lands.
      (kubectl-validate.override { buildGoModule = buildGo126Module; })
      kubectx
      kube-capacity
      kubernetes-helm
      k9s
      argocd
      rancher
    ];
  };
}
