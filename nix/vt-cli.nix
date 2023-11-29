{
  inputs,
  pkgs,
  ...
}: let
  pythonPackages = pkgs.python3.pkgs;
  vt-cli = pythonPackages.buildPythonApplication {
    pname = "vt-cli";
    version = "1.0";
    format = "pyproject";
    propagatedBuildInputs = with pythonPackages; [
      setuptools
      click
      pyperclip
      requests
      toml
    ];
    src = builtins.fetchGit {
      url = "git@bitbucket.org:velocitytrade/vt.cli.git";
      ref = "master";
      rev = "25c6d0fb0eb329b06275fdf1f1c7950ef6067ce5";
    };
  };
in {
  home.packages = [vt-cli];
}
