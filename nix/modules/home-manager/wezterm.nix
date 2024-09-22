{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.ez.programs.wezterm;
in {
  options.ez.programs.wezterm.enable = mkEnableOption "wezterm";

  config = mkIf cfg.enable {
    # TODO: wezterm is currently broken on macos
    # so I'm installing it with brew until this is fixed
    # see: https://github.com/NixOS/nixpkgs/issues/239384
    home.packages =
      if pkgs.stdenv.isLinux
      then [pkgs.wezterm]
      else [];

    xdg.configFile.wezterm = {
      source = ../../../wezterm;
      recursive = true;
    };
  };
}
