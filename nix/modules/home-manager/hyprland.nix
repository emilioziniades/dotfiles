{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ez.programs.hyprland;
in
{
  options.ez.programs.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      extraLuaFiles.config = ../../../hyprland/hyprland.lua;
    };

    home.packages = [ pkgs.hyprlauncher ];
  };
}
