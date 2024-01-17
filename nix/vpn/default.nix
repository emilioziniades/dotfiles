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
  paths = [script] ++ buildInputs;
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

  script = writeScriptBin name (builtins.readFile ./vpn.sh);

  openfortivpn-webview = callPackage ./openfortivpn-webview.nix {};

  buildInputs = [
    jq
    openfortivpn
    openfortivpn-webview
  ];

  nativeBuildInputs = [
    makeWrapper
  ];
}
