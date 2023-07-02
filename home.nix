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
      path = "~/.local/share/zsh";
    };
    initExtra = builtins.readFile ./zshrc;
  };

  programs.git = {
    enable = true;
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
