{
  pkgs,
  emilioExtraConfig,
  ...
}: {
  home.stateVersion = "24.05";
  home.username = emilioExtraConfig.username;
  home.homeDirectory = emilioExtraConfig.homeDirectory;
  programs.home-manager.enable = true;

  imports = [
    ./modules/home-manager/neovim.nix
    ./modules/home-manager/alacritty.nix
    ./modules/home-manager/tmux.nix
    ./modules/home-manager/tms.nix
    ./modules/home-manager/git.nix
    ./modules/home-manager/shells.nix
  ];

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
    defaultBranch = "main";
    gpgKey = "877E9B0125E55C17CF2E52DAEA106EB7199A20CA";
  };

  home.packages = with pkgs;
    [
      # GENERAL TOOLS
      curl
      file
      htop
      fd
      eza
      bat
      tree
      ripgrep
      fzf
      jq
      yq
      diffutils
      wget
      gnupg
      zip
      unzip
      gnumake
      mktemp
      xclip
      just
      tokei
      hey
      nmap
      nushell
      tmux-sessionizer
      watchexec
      timewarrior
      flyctl
      gh
      awscli2
      kubectl
      postgresql_15
      pgformatter
      cook-cli
      mongosh
      # imagemagick
      # ffmpeg
      # tor
      # pandoc

      # $WORK
      (pkgs.callPackage ./pkgs/vt-cli/package.nix {pythonPackages = python3.pkgs;})
      (pkgs.callPackage ./pkgs/vpn/package.nix {})

      # SHELL
      shfmt
      shellcheck

      # NIX
      alejandra
      manix
      nil

      # RUST
      cargo
      rustc
      rustfmt
      rust-analyzer
      clippy

      # GO
      go
      gopls
      gotools

      # PYTHON
      python311
      python311Packages.ipython
      python311Packages.black
      nodePackages.pyright

      # LUA
      lua
      stylua
      lua-language-server

      # JAVASCRIPT/TYPESCRIPT
      nodejs_18
      nodePackages.prettier
      nodePackages.typescript-language-server

      # DOTNET
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

      # IAC
      packer
      terraform
      terraform-ls

      # HASKELL
      ghc
      haskell-language-server
      haskellPackages.stack
      haskellPackages.fourmolu

      # C/C++
      gcc

      # HTML
      djlint
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      firefox
      obsidian
      mongodb-compass
      teams-for-linux
      spotify
      discord
      libreoffice
      # redisinsight
      # element-desktop
      # etcher
    ];
}
