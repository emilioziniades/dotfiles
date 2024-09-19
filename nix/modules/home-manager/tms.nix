{
  lib,
  pkgs,
  config,
  nix-std,
  ...
}:
with lib; let
  cfg = config.ez.programs.tms;
in {
  options.ez.programs.tms.enable = mkEnableOption "tms";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.tmux-sessionizer
    ];

    xdg.configFile."tms/config.toml".text = let
      # TODO: Make this module option-able and pass this in as config
      dirs = ["code" "work" "personal" "dotfiles" "obsidian"];
      mkSearchDir = dir: {
        path = "${config.home.homeDirectory}/${dir}";
        depth = 2;
      };
      tmsConfig = {
        search_dirs = map mkSearchDir dirs;
      };
    in
      nix-std.lib.serde.toTOML tmsConfig;
  };
}
