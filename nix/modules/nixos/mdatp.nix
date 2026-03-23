{ inputs, pkgs, ... }:
{
  age.secrets.mdatp = {
    file = "${inputs.dotfiles-secrets}/secrets/mdatp.age";
    path = "/etc/opt/microsoft/mdatp/mdatp_onboard.json";
    mode = "640";
  };

  services.mdatp = {
    enable = true;
    enableZshIntegration = false;
    package = pkgs.mdatp.overrideAttrs (_: {
      version = "101.26012.0007";
      src = pkgs.fetchurl {
        url = "https://packages.microsoft.com/debian/13/prod/pool/main/m/mdatp/mdatp_101.26012.0007_amd64.deb";
        hash = "sha256-6aAVO2fn7IcFTCeUBrRnUBG/rAJ60yujk2VMTLkm898=";
      };
      postInstall = ''
        for executable in $out/bin/mdatp $out/sbin/*; do
          wrapProgram $executable \
            --prefix NIX_LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.pcre2 ]}
        done
      '';
    });
  };
}
