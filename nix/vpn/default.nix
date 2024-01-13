{
  inputs,
  pkgs,
  ...
}: let
  name = "vpn";
  buildInputs = with pkgs; [
    jq
    openfortivpn
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
