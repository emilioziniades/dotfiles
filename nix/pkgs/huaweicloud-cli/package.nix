{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "huaweicloud-cli";
  version = "7.2.12";

  src = fetchurl {
    url = "https://hwcloudcli.obs.cn-north-1.myhuaweicloud.com/cli/${finalAttrs.version}/huaweicloud-cli-linux-amd64.tar.gz";
    hash = "sha256-66KUFMnmNoXYtcutKmevcMYMHrDtV2vHeazv1rpntx8=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hcloud $out/bin/hcloud
    install -Dm644 README.md OpenSourceSoftwareNotice.md -t $out/share/doc/huaweicloud-cli

    runHook postInstall
  '';

  meta = {
    description = "KooCLI, the official Huawei Cloud command line interface";
    homepage = "https://support.huaweicloud.com/intl/en-us/productdesc-hcli/hcli_01.html";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "hcloud";
    platforms = [ "x86_64-linux" ];
  };
})
