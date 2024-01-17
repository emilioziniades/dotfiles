{
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:
buildNpmPackage rec {
  pname = "openfortivpn-webview";
  version = "1.1.2-electron";

  project = fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${version}";
    sha256 = "sha256-BNotbb2pL7McBm0SQwcgEvjgS2GId4HVaxWUz/ODs6w=";
  };
  src = "${project}/openfortivpn-webview-electron";

  npmDepsHash = "sha256-FvonIgVWAB0mHQaYcJkrZ9pn/nrTju2Br5OkmtGFsIk";

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -R index.js node_modules $out
    echo "${electron}/bin/electron $out/index.js \$@" >> $out/bin/openfortivpn-webview
    chmod +x $out/bin/openfortivpn-webview
  '';
}
