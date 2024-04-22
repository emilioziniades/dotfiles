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
    rev = "2379adc2617046e7f73a39b0efb89900460e9467";
  };
}
