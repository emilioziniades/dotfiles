{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.ghostty;
in
{
  options.ez.programs.ghostty.enable = mkEnableOption "ghostty";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ghostty
    ];

    xdg.configFile.ghostty = {
      source = ../../../ghostty;
      recursive = true;
    };

  };
}
