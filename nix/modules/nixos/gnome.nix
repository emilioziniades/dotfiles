{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };

          "org/gnome/desktop/input-sources" = {
            xkb-options = [ "caps:escape" ];
          };

          "org/gnome/shell/keybindings" = {
            show-screenshot-ui = [ "Insert" ];
          };

        };

        locks = [
          "/org/gnome/desktop/interface/color-scheme"
        ];
      }
    ];
  };
}
