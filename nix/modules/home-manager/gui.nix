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
      # TODO: revert back to `libreoffice` when this issue is resolved:
      # https://github.com/NixOS/nixpkgs/issues/495635
      libreoffice-fresh
      bitwarden-desktop
      thunderbird
      pinta
    ];
  };
}
