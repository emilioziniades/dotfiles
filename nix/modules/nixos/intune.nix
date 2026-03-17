{ pkgs, config, ... }:
{
  services.intune.enable = true;

  # The upstream NixOS intune module doesn't enable these services
  # TODO: consider upstreaming these changes too
  systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
  systemd.user.services.intune-agent.wantedBy = [ "default.target" ];

  # intune-agent reads password policy from /etc/pam.d/common-password (Ubuntu convention),
  # which doesn't exist on NixOS. Create it so the agent can report compliance.
  environment.etc."pam.d/common-password".text = ''
    password required ${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so minlen=12 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 difok=6 shadowretry=3 enforce_for_root
    password sufficient ${pkgs.pam}/lib/security/pam_unix.so nullok yescrypt
  '';

  # Actually enforce password quality via PAM
  security.pam.services.passwd.rules.password.pwquality = {
    control = "required";
    modulePath = "${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so";
    order = config.security.pam.services.passwd.rules.password.unix.order - 10;
    settings = {
      shadowretry = 3;
      minlen = 12;
      difok = 6;
      dcredit = -1;
      ucredit = -1;
      ocredit = -1;
      lcredit = -1;
      enforce_for_root = true;
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      # TODO: upstream this
      intune-portal = prev.intune-portal.overrideAttrs (previousAttrs: {
        src = pkgs.fetchurl {
          url = "https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/i/intune-portal/intune-portal_1.2603.21-noble_amd64.deb";
          hash = "sha256-3UHLu4Kd4HtNkH7AaUT4Zx6wvU0UZnBXQ2ae7lh2Ucg=";
        };
      });
    })
  ];
}
