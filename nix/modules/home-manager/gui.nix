{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ez.applications.gui;
in {
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
      bitwarden
      thunderbird
      pinta
    ];
  };
}
