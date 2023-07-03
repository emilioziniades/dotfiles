#TODO: find better way to manage nix + nixpkgs config, nix-darwin maybe?
{pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings = {
      build-users-group = "nixbld";
      experimental-features = ["nix-command" "flakes"];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "nodejs-16.20.1"
    ];
  };

  home.packages = with pkgs; [
    htop
    fd
    fzf
    exa
    bat
    tree
    ripgrep
    jq
    diffutils
    wget
    flyctl
    gh
    timewarrior
    gnupg
    imagemagick
    postgresql_15
    tor
    pandoc
    nushell
    awscli2
    kubectl

    # GUI apps
    #TODO: get this working on darwin
    # discord
    # firefox-bin
    # vlc

    alejandra

    go
    gopls
    gotools

    (python311.withPackages
      (p: [
        p.ipython
        p.requests
        p.numpy
        p.pandas
        p.seaborn
      ]))

    lua
    stylua
    lua-language-server

    gcc11

    nodejs_16
    nodePackages.pyright

    (with dotnetCorePackages;
      combinePackages [
        sdk_6_0
        sdk_7_0
      ])
  ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      v = "nvim";
      t = "tmux";
      k = "kubectl";
      c = "clear && tmux clear-history";
      py = "python";
      ipy = "ipython";
      ll = "ls -alh --color=always";
      gr = "go run";
      gt = "go test";
      gtv = "go test -v .";
      cr = "cargo run";
      switch = "home-manager switch --flake ~/dotfiles";
    };
    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
    };
    history = {
      ignoreDups = true;
      share = true;
      save = 10000;
      size = 10000;
    };
    initExtra = builtins.readFile ./zshrc;
  };

  # TODO: instead of these hacky if else's everywhere, split into three files: nix-darwin, nix-os, and common to both
  programs.git = let
    isPersonal = pkgs.system == "x86_64-darwin";
  in {
    enable = true;
    userName = "Emilio Ziniades";
    userEmail =
      if isPersonal
      then "emilioziniades@protonmail.com"
      else "emilioz@za.velocitytrade.com";
    aliases = {
      i = "init";
      s = "status";
      l = "log --oneline --all";
      g = "log --oneline --graph --decorate --all";
      lf = "log";
      d = "diff";
      a = "add";
      c = "commit";
      p = "push";
    };
    extraConfig = {
      user = {
        signingkey =
          if isPersonal
          then "877E9B0125E55C17CF2E52DAEA106EB7199A20CA"
          else null;
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      commit = {
        gpgsign = false;
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      import = ["~/dotfiles/colours/catppuccin/alacritty/catppuccin-mocha.yml"];
      env = {
        TERM = "xterm-256color";
      };
      window.padding = {
        x = 10;
        y = 10;
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font Mono"; #TODO: install this nerdfont
          style = "Medium";
        };
        size = 14.0;
      };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./nvim/init.lua;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
