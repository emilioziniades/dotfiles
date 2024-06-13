{pkgs, ...}: {
  home.packages = with pkgs; [
    wezterm
  ];

  xdg.configFile.wezterm = {
    source = ../../../wezterm;
    recursive = true;
  };
}
