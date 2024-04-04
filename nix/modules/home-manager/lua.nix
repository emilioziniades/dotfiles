{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.lua = {
    enable = lib.mkEnableOption "Lua development tools";
  };

  config = lib.mkIf config.ez.programs.lua.enable {
    home.packages = with pkgs; [
      lua
      stylua
      lua-language-server
    ];
  };
}
