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
    rev = "b287929e1294b79fbbbcfa8276a911f7e8c52d49";
  };
}
