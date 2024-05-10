{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.webdev = {
    enable = lib.mkEnableOption "Web development tools";
  };

  config = lib.mkIf config.ez.programs.webdev.enable {
    home.packages = with pkgs; [
      # JAVASCRIPT/TYPESCRIPT
      nodejs_20
      nodePackages.prettier
      nodePackages.typescript-language-server

      # HTML
      djlint
    ];
  };
}
