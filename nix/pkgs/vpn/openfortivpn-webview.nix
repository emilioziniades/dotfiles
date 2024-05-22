{
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:
buildNpmPackage rec {
  pname = "openfortivpn-webview";
  version = "1.2.0-electron";

  project = fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${version}";
    sha256 = "sha256-HheqDjlWxHJS0+OEhRTwANs9dyz3lhhCmWh+YH4itOk=";
  };
  src = "${project}/openfortivpn-webview-electron";

  npmDepsHash = "sha256-Vf8R0+RXHlXwPOnPENw8ooxIXT3kSppQmB2yk5TWEwg=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -R index.js node_modules $out
    echo "${electron}/bin/electron $out/index.js \$@" >> $out/bin/openfortivpn-webview
    chmod +x $out/bin/openfortivpn-webview
  '';
}
