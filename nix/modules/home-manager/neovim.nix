{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.neovim;
in
{
  options.ez.programs.neovim.enable = mkEnableOption "neovim";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    xdg.configFile.nvim = {
      source = ../../../nvim;
      recursive = true;
    };
  };
}
