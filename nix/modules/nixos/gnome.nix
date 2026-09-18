{
  pkgs,
  ...
}:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  environment.systemPackages = [
    pkgs.gnomeExtensions."hide-top-bar"
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ pkgs.gnomeExtensions."hide-top-bar".extensionUuid ];
          };

          "org/gnome/shell/extensions/hidetopbar" = {
            shortcut-keybind = [ "<Super>b" ];
            shortcut-toggles = true;
          };
        };
      }
    ];
  };
}
