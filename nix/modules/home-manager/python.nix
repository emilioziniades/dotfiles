{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.python = {
    enable = lib.mkEnableOption "Python development tools";
  };

  config = lib.mkIf config.ez.programs.python.enable {
    home.packages = with pkgs; [
      python311
      python311Packages.ipython
      ruff
      nodePackages.pyright
    ];
  };
}