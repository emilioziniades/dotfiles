{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.ez.programming;
in {
  options.ez.programming = {
    python.enable = mkEnableOption "python";
    go.enable = mkEnableOption "go";
    rust.enable = mkEnableOption "rust";
    typescript.enable = mkEnableOption "typescript";
    dotnet.enable = mkEnableOption "dotnet";
    haskell.enable = mkEnableOption "haskell";
    lua.enable = mkEnableOption "lua";
    html.enable = mkEnableOption "html";
    nix.enable = mkEnableOption "nix";
    terraform.enable = mkEnableOption "terraform";
    packer.enable = mkEnableOption "packer";
    markdown.enable = mkEnableOption "markdown";
    bash.enable = mkEnableOption "bash";
    postgres.enable = mkEnableOption "postgres";
    nushell.enable = mkEnableOption "nushell";
  };

  config = mkMerge [
    (mkIf cfg.python.enable {
      home.packages = with pkgs; [
        python3
        python3Packages.ipython
        ruff
        uv
        pyright
      ];
    })

    (mkIf cfg.go.enable {
      home.packages = with pkgs; [
        go
        gopls
        gotools
        gofumpt
      ];
    })

    (mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        cargo
        rustc
        rustfmt
        rust-analyzer
        clippy
      ];
    })

    (mkIf cfg.typescript.enable {
      home.packages = with pkgs; [
        nodejs_20
        nodePackages.prettier
        nodePackages.typescript-language-server
      ];
    })

    (mkIf cfg.dotnet.enable {
      home.packages = with pkgs; [
        (with dotnetCorePackages;
          combinePackages [
            sdk_8_0
            sdk_9_0
          ])
        csharp-ls
        csharpier
        netcoredbg
        dotnet-outdated
        csharprepl
        fsautocomplete
        fantomas
      ];
      home.sessionVariables = {
        DOTNET_CLI_TELEMETRY_OPTOUT = 1;
        DOTNET_NOLOGO = 1;
      };
    })

    (mkIf cfg.haskell.enable {
      home.packages = with pkgs; [
        ghc
        haskell-language-server
        haskellPackages.stack
        haskellPackages.fourmolu
      ];
    })

    (mkIf cfg.lua.enable {
      home.packages = with pkgs; [
        lua
        stylua
        lua-language-server
      ];
    })

    (mkIf cfg.html.enable {
      home.packages = with pkgs; [
        djlint
      ];
    })

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        alejandra
        manix
        nil
      ];
    })

    (mkIf cfg.terraform.enable {
      home.packages = with pkgs; [
        opentofu
        terraform-ls
        tflint
      ];
    })

    (mkIf cfg.packer.enable {
      home.packages = with pkgs; [
        packer
      ];
    })

    (mkIf cfg.markdown.enable {
      home.packages = with pkgs; [
        markdown-oxide
      ];
    })

    (mkIf cfg.bash.enable {
      programs.bash.enable = true;

      home.packages = with pkgs; [
        bash-language-server
        shfmt
        shellcheck
      ];
    })

    (mkIf cfg.postgres.enable {
      home.packages = with pkgs; [
        postgresql
        pgformatter
      ];
    })

    (mkIf cfg.nushell.enable {
      programs.nushell.enable = true;
    })
  ];
}
