{
  stdenv,
  fetchFromGitHub,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "openfortivpn-webview";
  version = "1.2.0-electron";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HheqDjlWxHJS0+OEhRTwANs9dyz3lhhCmWh+YH4itOk=";
  };
  sourceRoot = "${src.name}/openfortivpn-webview-qt";

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    qt6.qtwayland
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv openfortivpn-webview $out/bin/
    runHook postInstall
  '';
}
