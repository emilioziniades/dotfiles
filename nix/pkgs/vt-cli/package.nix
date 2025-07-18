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
    boto3
  ];
  src = builtins.fetchGit {
    url = "git@bitbucket.org:velocitytrade/vt.cli.git";
    ref = "master";
    rev = "e50948e54e1bb91254c06d3ba6e008f4659894e0";
  };
}
