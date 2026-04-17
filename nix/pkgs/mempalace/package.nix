{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mempalace";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milla-jovovich";
    repo = "mempalace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nmU3d4Jj00YwpNl31tL9xsyDGXsGUM9Wp0tBWB9+p7E=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    chromadb
    pyyaml
  ];

  doCheck = false;

  meta = {
    description = "Give your AI a memory — mine projects and conversations into a searchable palace";
    mainProgram = "mempalace";
    homepage = "https://github.com/milla-jovovich/mempalace";
    license = lib.licenses.mit;
  };
})
