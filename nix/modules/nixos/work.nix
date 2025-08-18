{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cloudflare-warp
  ];
}
