{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.ghostty;
in
{
  options.ez.programs.ghostty.enable = mkEnableOption "ghostty";

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "MonaspiceNe Nerd Font";
        window-decoration = "none";
        title = "Ghostty";
      };
    };
  };
}
