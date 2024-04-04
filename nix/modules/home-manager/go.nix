{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.go = {
    enable = lib.mkEnableOption "Go development tools";
  };

  config = lib.mkIf config.ez.programs.go.enable {
    home.packages = with pkgs; [
      go
      gopls
      gotools
    ];
  };
}
