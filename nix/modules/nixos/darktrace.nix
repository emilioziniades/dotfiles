{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.ez.services.darktrace;
in
{
  options.ez.services.darktrace = with types; {
    enable = mkEnableOption "darktrace";

    package = mkOption {
      type = package;
      description = "The darktrace-csensor package";
    };

    setupFile = mkOption {
      type = str;
      default = "/etc/darktrace-csensor/setup";
      description = ''
        Path to the darktrace-csensor setup file at runtime.
        This file is read once during initial setup and should contain
        the server address, key ID, and key, one per line.
        The caller is responsible for providing this file (e.g. via agenix, sops-nix, etc.).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    systemd.packages = [
      cfg.package
    ];

    systemd.services.darktrace-setup = {
      description = "Darktrace cSensor initial setup";
      wantedBy = [ "multi-user.target" ];
      before = [
        "darktrace-csensor.service"
        "darktrace-ebpf.service"
      ];
      unitConfig.ConditionPathExists = "!/var/lib/darktrace-csensor/darktrace-csensor.db";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "darktrace-setup" ''
          ${cfg.package}/share/darktrace-csensor/bin/darktrace-csensor < ${cfg.setupFile}
        '';
      };
    };

    # NixOS stores CA bundles in the nix store with 555 (r-xr-xr-x) permissions.
    # Darktrace rejects CA bundles with execute bits set ("suspicious permission settings").
    # Override to create regular files with 0644 permissions instead of symlinks to nix store.
    environment.etc."ssl/certs/ca-bundle.crt" = lib.mkForce {
      source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      mode = "0644";
    };
    environment.etc."ssl/certs/ca-certificates.crt" = lib.mkForce {
      source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      mode = "0644";
    };
    environment.etc."pki/tls/certs/ca-bundle.crt" = lib.mkForce {
      source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      mode = "0644";
    };

    systemd.services.darktrace-csensor = {
      wantedBy = [ "multi-user.target" ];
      after = [ "darktrace-setup.service" ];
      requires = [ "darktrace-setup.service" ];
    };

    systemd.services.darktrace-ebpf = {
      wantedBy = [ "multi-user.target" ];
      after = [ "darktrace-setup.service" ];
      requires = [ "darktrace-setup.service" ];
    };
  };
}
