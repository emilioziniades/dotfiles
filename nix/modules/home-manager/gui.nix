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
      # TODO: set below back to `obsidian` after this lands: https://nixpk.gs/pr-tracker.html?pr=510075
      (obsidian.override { electron = electron_39; })
      teams-for-linux
      spotify
      discord
      libreoffice
      bitwarden-desktop
      thunderbird
      pinta
    ];
  };
}
