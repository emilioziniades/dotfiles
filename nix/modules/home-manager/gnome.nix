{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ez.programs.gnome;
in
{
  options.ez.programs.gnome.enable = lib.mkEnableOption "GNOME desktop configuration";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnomeExtensions."hide-top-bar"
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ pkgs.gnomeExtensions."hide-top-bar".extensionUuid ];
      };

      "org/gnome/shell/extensions/hidetopbar" = {
        shortcut-keybind = [ "<Super>b" ];
        shortcut-toggles = true;
      };
    };
  };
}
