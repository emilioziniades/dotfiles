{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cw";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilioziniades";
    repo = "cw";
    rev = finalAttrs.version;
    hash = "sha256-Mv7EyEHB6CiidLF89GUKrqaBaWEhbeBx+9IMZyO20cg=";
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
    markdownify
  ];

  nativeBuildInputs = [ installShellFiles ];

  postFixup = ''
    _CW_COMPLETE=bash_source $out/bin/cw > cw.bash
    _CW_COMPLETE=zsh_source $out/bin/cw > cw.zsh
    _CW_COMPLETE=fish_source $out/bin/cw > cw.fish

    installShellCompletion --cmd cw --bash cw.bash --zsh cw.zsh --fish cw.fish
  '';

  meta = {
    description = "A command-line crossword client";
    homepage = "https://github.com/emilioziniades/cw";
    license = lib.licenses.mit;
    mainProgram = "cw";
  };
})
