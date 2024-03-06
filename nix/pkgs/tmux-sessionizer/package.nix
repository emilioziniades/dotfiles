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

  version = "3611edb8772e5f43ea8b476c6fead012881e1c43";

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = name;
    rev = version;
    hash = "sha256-Y9uAf7Q+lbkLRIaySmprvEYDIoZ1b61rR+TyEIkIcqE=";
  };

  cargoHash = "sha256-vHJtBEzDzP7jdE0bsmVhUojZITXd0C6j88T6Ku4NQSY=";

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl] ++ lib.optionals stdenv.isDarwin [Security];
}
