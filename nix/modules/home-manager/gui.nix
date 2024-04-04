{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.ez.applications.gui;
in {
  options.ez.applications.gui = {
    enable = mkEnableOption "GUI applications";
  };

  config = mkIf cfg.enable {
    home.packages = [
      firefox
      obsidian
      mongodb-compass
      teams-for-linux
      spotify
      discord
      libreoffice
      # TODO: add bitwarden GUI
    ];
  };
}
