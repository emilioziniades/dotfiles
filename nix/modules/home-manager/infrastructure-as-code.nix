{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.infrastructure-as-code = {
    enable = lib.mkEnableOption "IAC development tools";
  };

  config = lib.mkIf config.ez.programs.infrastructure-as-code.enable {
    home.packages = with pkgs; [
      packer
      opentofu
      terraform-ls
    ];
  };
}
