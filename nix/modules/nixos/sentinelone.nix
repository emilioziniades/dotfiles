{
  pkgs,
  config,
  inputs,
  ...
}: let
  sentinelone = inputs.sentinelone.packages.${pkgs.system}.sentinelone.overrideAttrs (finalAttrs: prevAttrs: {
    src = "${inputs.dotfiles-secrets}/files/SentinelAgent_linux_x86_64_v24_2_1_8.deb";
  });
in {
  services.sentinelone.enable = true;
  services.sentinelone.package = sentinelone;
  services.sentinelone.email = "emilioz@za.velocitytrade.com";
  services.sentinelone.serialNumber = "0";
  services.sentinelone.sentinelOneManagementTokenPath = config.age.secrets.sentinelone-management-token.path;

  age.secrets.sentinelone-management-token.file = "${inputs.dotfiles-secrets}/secrets/sentinelone-management-token.age";
  age.identityPaths = ["/home/emilioz/.ssh/id_rsa"];
}
