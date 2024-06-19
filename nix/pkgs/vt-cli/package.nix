{pythonPackages, ...}:
pythonPackages.buildPythonApplication {
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
    rev = "b27478e84cff736b419d9f9119c954dfa8bc14a5";
  };
}
