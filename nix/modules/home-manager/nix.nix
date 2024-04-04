{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.nix = {
    enable = lib.mkEnableOption "Nix development tools";
  };

  config = lib.mkIf config.ez.programs.nix.enable {
    home.packages = with pkgs; [
      alejandra
      manix
      nil
    ];
  };
}
