{pkgs, ...}: {
  services.cloudflare-warp.enable = true;

  environment.systemPackages = with pkgs; [
    cloudflare-warp
    gnomeExtensions.cloudflare-warp-toggle
  ];
}
