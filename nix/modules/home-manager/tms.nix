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
    # TODO: Make this module option-able and pass this in as config
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
