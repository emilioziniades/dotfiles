{pkgs}:
pkgs.buildNpmPackage rec {
  pname = "openfortivpn-webview";
  version = "1.1.2-electron";

  project = pkgs.fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${version}";
    sha256 = "sha256-BNotbb2pL7McBm0SQwcgEvjgS2GId4HVaxWUz/ODs6w=";
  };
  src = "${project}/openfortivpn-webview-electron";

  npmDepsHash = "sha256-FvonIgVWAB0mHQaYcJkrZ9pn/nrTju2Br5OkmtGFsIk";

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  buildInputs = [
  ];

  # postPatch = ''
  #   substituteInPlace scripts/build-.sh \
  #     --replace 'if [ "$1" == "snap" ]; then' 'exit 0; if [ "$1" == "snap" ]; then'
  # '';

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  electron = pkgs.electron;

  dontNpmBuild = true;
  postBuild = ''
    # npm run build --workspace=packages/bruno-graphql-docs
    # npm run build --workspace=packages/bruno-app
    # npm run build --workspace=packages/bruno-query

    # bash scripts/build-.sh

    # pushd packages/bruno-
    # ls -aR {electron}
    # echo "FUCK"
    # exit 1

    npm exec -builder -- \
      --dir \
      -c.Dist=${electron}/bin/electron \
      -c.Version=${electron.version} \
      -c.npmRebuild=false

    # popd
  '';

  # npmPackFlags = ["--ignore-scripts"];

  installPhase = ''
    runHook preInstall

    echo "WE GOT HERE MOTHERFLUFFER"
    exit 1

    # mkdir -p $out/opt/bruno $out/bin
    #
    # cp -r packages/bruno-/dist/linux-unpacked/{locales,resources{,.pak}} $out/opt/bruno
    #
    # makeWrapper $lib.getExe  $out/bin/bruno \
    #   --add-flags $out/opt/bruno/resources/app.asar \
    #
    # runHook postInstall
  '';
}
