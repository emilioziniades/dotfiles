{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  Security,
}:
rustPlatform.buildRustPackage rec {
  name = "tmux-sessionizer";
  pname = name;

  version = "8f753a9baa13ed077f750c85fa4cd2997bf57b09";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = version;
    hash = "sha256-wJ258HPPpjvlzNEWiRwk9IwxPiCrX26MiP83iyQEgDY=";
  };

  cargoHash = "sha256-5A/mG+vxuu7wXiVvEbrMCNCLGRQRMv8qmwBJ5m7mZhA=";

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl] ++ lib.optionals stdenv.isDarwin [Security];
}
