{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cw";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilioziniades";
    repo = "cw";
    rev = finalAttrs.version;
    hash = "sha256-e0OrYnAPptLVEKh/9yFLZWI7msfbVVSvHMogEIdAdAc=";
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
