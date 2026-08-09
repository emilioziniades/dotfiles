{
  config,
  ...
}:
{
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
