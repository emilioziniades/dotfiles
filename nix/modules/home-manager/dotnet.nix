{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ez.programs.dotnet = {
    enable = lib.mkEnableOption "Dotnet development tools";
  };

  config = lib.mkIf config.ez.programs.dotnet.enable {
    home.packages = with pkgs; [
      (with dotnetCorePackages;
        combinePackages [
          sdk_6_0
          sdk_8_0
        ])
      csharp-ls
      csharpier
      netcoredbg
      dotnet-outdated
      csharprepl
    ];

    home.sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = 1;
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
      DOTNET_NOLOGO = 1;
    };
  };
}