{
  callPackage,
  makeWrapper,
  writeScriptBin,
  symlinkJoin,
  openfortivpn,
  jq,
  ...
}:
symlinkJoin rec {
  name = "vpn";
  paths = [script] ++ runtimeInputs;
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

  script =
    (writeScriptBin name (builtins.readFile ./vpn.sh))
    .overrideAttrs (old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });

  openfortivpn-webview = callPackage ./openfortivpn-webview.nix {};

  runtimeInputs = [
    jq
    openfortivpn
    openfortivpn-webview
  ];

  buildInputs = [
    makeWrapper
  ];
}
