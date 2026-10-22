{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.android;
  androidsdk =
    ((pkgs.androidenv.override { licenseAccepted = true; }).composeAndroidPackages {
      includeEmulator = true;
      includeSystemImages = true;
      platformVersions = [ "36" ];
      systemImageTypes = [ "google_apis_playstore" ];
      abiVersions = [ "x86_64" ];
    }).androidsdk;
in
{
  options.ez.programs.android.enable = mkEnableOption "android";

  config = mkIf cfg.enable {
    home.packages = [ androidsdk ];
    home.file.".androidrc".text = "--sdk=${androidsdk}/libexec/android-sdk\n";
  };
}
