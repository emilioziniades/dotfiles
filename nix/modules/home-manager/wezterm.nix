{pkgs, ...}: {
  # TODO: wezterm is currently broken on macos
  # so I'm installing it with brew until this is fixed
  # see: https://github.com/NixOS/nixpkgs/issues/239384
  home.packages = with pkgs;
    if stdenv.isLinux
    then [wezterm]
    else [];

  xdg.configFile.wezterm = {
    source = ../../../wezterm;
    recursive = true;
  };
}
