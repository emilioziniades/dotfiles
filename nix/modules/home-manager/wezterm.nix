{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.wezterm;
in
{
  options.ez.programs.wezterm.enable = mkEnableOption "wezterm";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wezterm ];

    xdg.configFile.wezterm = {
      source = ../../../wezterm;
      recursive = true;
    };
  };
}
