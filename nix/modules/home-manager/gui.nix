{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.ez.applications.gui;
in
{
  options.ez.applications.gui = {
    enable = mkEnableOption "GUI applications";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox
      obsidian
      teams-for-linux
      spotify
      discord
      libreoffice
      # TODO: uncomment below once resolved: https://github.com/NixOS/nixpkgs/issues/526914
      # bitwarden-desktop
      thunderbird
      gradia
    ];
  };
}
