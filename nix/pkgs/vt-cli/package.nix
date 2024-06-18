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
    rev = "ad40a60467da25c96a32edbbc8c97126f70bf8f8";
  };
}
