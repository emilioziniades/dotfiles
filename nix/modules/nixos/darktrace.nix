{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.ez.services.darktrace;
  version = "2.7.6";
  darktrace-csensor = pkgs.stdenv.mkDerivation {
    pname = "darktrace-csensor";
    version = version;
    src = "${inputs.dotfiles-secrets}/files/darktrace-csensor_2.7.9_amd64.deb";

    nativeBuildInputs = with pkgs; [ dpkg ];

    buildPhase = ''
      runHook preBuild
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/darktrace-csensor/bin $out/lib/systemd/system

      cp -a var/lib/darktrace-csensor/current/darktrace-csensor $out/share/darktrace-csensor/
      cp -a var/lib/darktrace-csensor/current/bin/darktrace-csensor $out/share/darktrace-csensor/bin/
      cp -a var/lib/darktrace-csensor/current/darktrace-ebpf $out/share/darktrace-csensor/

      ln -s ../share/darktrace-csensor/darktrace-csensor $out/bin/darktrace-csensor
      ln -s ../share/darktrace-csensor/darktrace-ebpf $out/bin/darktrace-ebpf

      substituteInPlace $out/share/darktrace-csensor/darktrace-csensor \
        --replace \
          'export PATH="/bin:/usr/bin"' \
          'export PATH="/bin:/usr/bin:${pkgs.coreutils}/bin"'

      substituteInPlace $out/share/darktrace-csensor/darktrace-csensor \
        --replace \
          'CRASH_DIR="''${DIR}/crash"' \
          'CRASH_DIR="/var/lib/darktrace-csensor/crash"'

      cp -a usr/lib/systemd/system/darktrace-csensor.service $out/lib/systemd/system/
      cp -a usr/lib/systemd/system/darktrace-ebpf.service $out/lib/systemd/system/

      substituteInPlace $out/lib/systemd/system/darktrace-csensor.service \
        --replace \
          "ExecStart = /var/lib/darktrace-csensor/current/darktrace-csensor" \
          "ExecStart = $out/share/darktrace-csensor/darktrace-csensor"

      substituteInPlace $out/lib/systemd/system/darktrace-ebpf.service \
        --replace \
          "ExecStart = /var/lib/darktrace-csensor/current/darktrace-ebpf" \
          "ExecStart = $out/share/darktrace-csensor/darktrace-ebpf"

      runHook postInstall
    '';
  };
in
{
  options.ez.services.darktrace = with types; {
    enable = mkEnableOption "darktrace";

    agenix-secret = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.darktrace = {
      file = cfg.agenix-secret;
      path = "/etc/darktrace-csensor/setup";
    };

    environment.systemPackages = [
      darktrace-csensor
    ];

    systemd.packages = [
      darktrace-csensor
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
          ${darktrace-csensor}/share/darktrace-csensor/bin/darktrace-csensor < /etc/darktrace-csensor/setup
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
