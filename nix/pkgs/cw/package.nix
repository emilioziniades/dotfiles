{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cw";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilioziniades";
    repo = "cw";
    rev = finalAttrs.version;
    hash = "sha256-RTuM827pBUGbDtuJymgFwVpyq0wCeC4IvyY9IbGBTos=";
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
