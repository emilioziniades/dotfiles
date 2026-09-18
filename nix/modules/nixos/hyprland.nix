{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock.enable = true;

  security.pam.services.hyprlock = {
    fprintAuth = true;
    unixAuth = true;
  };
}
