{
  pkgs,
  config,
  sentinelone,
  dotfiles-secrets,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      sentinelone = sentinelone.packages.${pkgs.system}.sentinelone.overrideAttrs (finalAttrs: prevAttrs: {
        src = "${dotfiles-secrets}/files/SentinelAgent_linux_x86_64_v24_2_1_8.deb";
      });
    })
  ];

  environment.systemPackages = [pkgs.sentinelone];

  services.sentinelone.enable = true;
  services.sentinelone.email = "emilioz@za.velocitytrade.com";
  services.sentinelone.serialNumber = "0";
  services.sentinelone.sentinelOneManagementTokenPath = config.age.secrets.sentinelone-management-token.path;

  age.secrets.sentinelone-management-token.file = "${dotfiles-secrets}/secrets/sentinelone-management-token.age";
}
