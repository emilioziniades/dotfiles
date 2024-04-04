{
  pkgs,
  config,
  nix-std,
  ...
}: {
  home.packages = [
    pkgs.tmux-sessionizer
  ];

  xdg.configFile."tms/config.toml".text = let
    dirs = ["code" "work" "personal" "dotfiles"];
    mkSearchDir = dir: {
      path = "${config.home.homeDirectory}/${dir}";
      depth = 2;
    };
    tmsConfig = {
      search_dirs = map mkSearchDir dirs;
    };
  in
    nix-std.lib.serde.toTOML tmsConfig;
}
