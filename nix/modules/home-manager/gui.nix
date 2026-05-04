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
      # TODO: remove this override once this is resolved:
      # https://github.com/NixOS/nixpkgs/issues/512444
      (teams-for-linux.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ yq-go ];
        postPatch = (old.postPatch or "") + ''
          yq -iP '.desktopName = "teams-for-linux.desktop"' package.json
        '';
      }))
      spotify
      discord
      libreoffice
      bitwarden-desktop
      thunderbird
      pinta
    ];
  };
}
