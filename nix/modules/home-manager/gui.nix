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
      # TODO: set below back to `obsidian` after this issue is resolved:
      # - https://github.com/NixOS/nixpkgs/issues/505078
      # - https://github.com/NixOS/nixpkgs/pull/505535
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
