{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.rust = {
    enable = lib.mkEnableOption "Rust development tools";
  };

  config = lib.mkIf config.ez.programs.rust.enable {
    home.packages = with pkgs; [
      cargo
      rustc
      rustfmt
      rust-analyzer
      clippy
    ];
  };
}
