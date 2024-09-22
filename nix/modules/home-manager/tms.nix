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
  options.ez.programs.tms = with types; {
    enable = mkEnableOption "tms";
    searchDirs = mkOption {
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.tmux-sessionizer
    ];

    xdg.configFile."tms/config.toml".text = let
      mkSearchDir = dir: {
        path = "${config.home.homeDirectory}/${dir}";
        depth = 2;
      };
      tmsConfig = {
        search_dirs = map mkSearchDir cfg.searchDirs;
      };
    in
      nix-std.lib.serde.toTOML tmsConfig;
  };
}
