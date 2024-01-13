{
  inputs,
  pkgs,
  ...
}: let
  name = "vpn";
  openfortivpn-webview = pkgs.callPackage ./openfortivpn-webview.nix {};
  buildInputs = with pkgs; [
    jq
    openfortivpn
    openfortivpn-webview
  ];
  script =
    (pkgs.writeScriptBin name (builtins.readFile ./vpn.sh))
    .overrideAttrs (old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
  vpn = pkgs.symlinkJoin {
    name = name;
    paths = [script] ++ buildInputs;
    buildInputs = [pkgs.makeWrapper];
    postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
  };
in {
  home.packages = [vpn];
}
