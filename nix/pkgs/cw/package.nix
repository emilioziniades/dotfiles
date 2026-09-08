{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cw";
  version = "0.1.0-unstable-2026-09-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilioziniades";
    repo = "cw";
    rev = "d8286344d95c395f30d86806ca3599848bb31e3b";
    hash = "sha256-oxtRHJ3vUZVWdkGzLadDTLpwzGRKALNax7vwjvNMyZM=";
  };

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    platformdirs
    pytest
    requests
    rich
  ];

  meta = {
    description = "A command-line crossword client";
    homepage = "https://github.com/emilioziniades/cw";
    license = lib.licenses.mit;
    mainProgram = "cw";
  };
})
