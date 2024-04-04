{
  pkgs,
  emilioExtraConfig,
  ...
}: {
  home.stateVersion = "24.05";
  home.username = emilioExtraConfig.username;
  home.homeDirectory = emilioExtraConfig.homeDirectory;
  programs.home-manager.enable = true;

  nixpkgs.config = {
    #allowUnfree = true;
    # see for below voodoo: https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  imports = [
    ./modules/home-manager/neovim.nix
    ./modules/home-manager/alacritty.nix
    ./modules/home-manager/tmux.nix
    ./modules/home-manager/tms.nix
    ./modules/home-manager/git.nix
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

  home.shellAliases = {
    c = "clear && tmux clear-history";
    copy =
      if pkgs.stdenv.isLinux
      then "xclip -selection clipboard"
      else "pbcopy";
    ls = "eza";
    cat = "bat";
    find = "fd";
    grep = "rg";
    switch = emilioExtraConfig.switchCommand;
  };

  # for profiling zsh startup times, see: https://esham.io/2018/02/zsh-profiling
  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
      DOTNET_CLI_TELEMETRY_OPTOUT = 1;
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
      GPG_TTY = "$(tty)";
    };
    history = {
      ignoreDups = true;
      share = true;
      save = 10000;
      size = 10000;
    };
    syntaxHighlighting.enable = true;
    initExtra = ''
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
    '';
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      aws.disabled = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
