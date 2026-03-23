{
  stdenv,
  dpkg,
  coreutils,
  src,
  version ? "2.7.9",
}:
stdenv.mkDerivation {
  pname = "darktrace-csensor";
  inherit version src;

  nativeBuildInputs = [ dpkg ];
  buildInputs = [ coreutils ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/darktrace-csensor/bin $out/lib/systemd/system

    cp -a var/lib/darktrace-csensor/current/darktrace-csensor $out/share/darktrace-csensor/
    cp -a var/lib/darktrace-csensor/current/bin/darktrace-csensor $out/share/darktrace-csensor/bin/
    cp -a var/lib/darktrace-csensor/current/darktrace-ebpf $out/share/darktrace-csensor/

    ln -s ../share/darktrace-csensor/darktrace-csensor $out/bin/darktrace-csensor
    ln -s ../share/darktrace-csensor/darktrace-ebpf $out/bin/darktrace-ebpf

    substituteInPlace $out/share/darktrace-csensor/darktrace-csensor \
      --replace-fail \
        'export PATH="/bin:/usr/bin"' \
        'export PATH="/bin:/usr/bin:${coreutils}/bin"'

    substituteInPlace $out/share/darktrace-csensor/darktrace-csensor \
      --replace-fail \
        'CRASH_DIR="''${DIR}/crash"' \
        'CRASH_DIR="/var/lib/darktrace-csensor/crash"'

    cp -a usr/lib/systemd/system/darktrace-csensor.service $out/lib/systemd/system/
    cp -a usr/lib/systemd/system/darktrace-ebpf.service $out/lib/systemd/system/

    substituteInPlace $out/lib/systemd/system/darktrace-csensor.service \
      --replace-fail \
        "ExecStart = /var/lib/darktrace-csensor/current/darktrace-csensor" \
        "ExecStart = $out/share/darktrace-csensor/darktrace-csensor"

    substituteInPlace $out/lib/systemd/system/darktrace-ebpf.service \
      --replace-fail \
        "ExecStart = /var/lib/darktrace-csensor/current/darktrace-ebpf" \
        "ExecStart = $out/share/darktrace-csensor/darktrace-ebpf"

    runHook postInstall
  '';
}
