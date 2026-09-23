{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cw";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilioziniades";
    repo = "cw";
    rev = finalAttrs.version;
    hash = "sha256-44zaE3LNI3nLh5CUCTpVRyyOAiNb2hv3Z3e8kjKEe3o=";
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
