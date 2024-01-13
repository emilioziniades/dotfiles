{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "openfortivpn-webview";
  version = "1.1.2-electron";
  src = pkgs.fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "607dc949730f24611a6dba6c5c6cb9a5669fd7ac";
    sha256 = "sha256-SZaC5bN2cYaMIOhqxisd3AXqKO4P/kmBcbg0IaEflr4=";
  };
  nativeBuildInputs = with pkgs; [
    libsForQt5.qt5.qtwebengine
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.wrapQtAppsHook
    gnumake
    gcc
  ];
  buildPhase = ''
    cd openfortivpn-webview-qt
    qmake .
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    # cp openfortivpn-webview /$out/bin
    cp ./openfortivpn-webview.app/Contents/MacOS/openfortivpn-webview /$out/bin
  '';
}
