{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.haskell = {
    enable = lib.mkEnableOption "Haskell development tools";
  };

  config = lib.mkIf config.ez.programs.haskell.enable {
    home.packages = with pkgs; [
      ghc
      haskell-language-server
      haskellPackages.stack
      haskellPackages.fourmolu
    ];
  };
}
