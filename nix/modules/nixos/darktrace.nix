{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.services.darktrace;
in
{
  options.ez.services.darktrace = with types; {
    enable = mkEnableOption "darktrace";

    agenix-secret = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    config.age.secrets.darktrace = {
      file = cfg.agenix-secret;
      path = "/etc/darktrace-csensor/setup";
    };
  };
}
