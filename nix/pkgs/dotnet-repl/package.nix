{
  buildDotnetGlobalTool,
  dotnet-sdk_8,
}:
buildDotnetGlobalTool {
  pname = "dotnet-repl";
  version = "0.1.216";
  executables = "dotnet-repl";
  nugetSha256 = "sha256-JHatCW+hl2792S+HYeEbbYbCIS+N4DmOctqXB/56/HU=";
  dotnet-runtime = dotnet-sdk_8;
  dotnet-sdk = dotnet-sdk_8;
}
