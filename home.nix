{
  pkgs,
  config,
  emilioExtraConfig,
  openfortivpn-cli,
  ...
}: {
  home.stateVersion = "23.11";

  home.username = emilioExtraConfig.username;
  home.homeDirectory = emilioExtraConfig.homeDirectory;

  nixpkgs.config = {
    #allowUnfree = true;
    # see for below voodoo: https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "electron-12.2.3"
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
    yq
    diffutils
    wget
    flyctl
    gh
    timewarrior
    gnupg
    postgresql_15
    nushell
    awscli2
    kubectl
    zip
    unzip
    gnumake
    tmux-sessionizer
    xclip
    # imagemagick
    # tor
    # pandoc

    # issue with openGL on non-NixOS systems, see https://github.com/NixOS/nixpkgs/issues/9415
    # openfortivpn-cli

    alejandra
    manix

    # rustc
    # cargo

    # go
    # gopls
    # gotools

    # (python311.withPackages
    #   (p: [
    #     p.pip
    #     p.ipython
    #     p.requests
    #     p.numpy
    #     p.pandas
    #     p.seaborn
    #   ]))
    #
    # lua
    # stylua
    # lua-language-server

    gcc11

    nodejs_16
    nodePackages.pyright
    nodePackages.prettier

    # (with dotnetCorePackages;
    #   combinePackages [
    #     sdk_6_0
    #     sdk_7_0
    #   ])
  ];
  # ++ lib.optionals pkgs.stdenv.isLinux [
  # firefox
  # obsidian
  # mongodb-compass
  # remmina
  # teams
  # spotify
  # element-desktop
  # discord
  # etcher
  # ];

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
      venv = "python -m venv venv";
      activate = "source venv/bin/activate";
      ll = "ls -alh --color=always";
      gr = "go run";
      gt = "go test";
      gtv = "go test -v .";
      cr = "cargo run";
      copy = "xclip -selection clipboard";
      hist = "history | grep";
      switch = emilioExtraConfig.switchCommand;
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

  programs.git = {
    enable = true;
    userName = "Emilio Ziniades";
    userEmail = emilioExtraConfig.gitEmail;
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
        signingkey = emilioExtraConfig.gitGpgKey;
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
          family = "FiraCode Nerd Font Mono";
          style = "Medium";
        };
        size = 14.0;
      };
    };
  };

  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 100000;
    escapeTime = 10;
    sensibleOnTop = false;
    plugins = with pkgs; [
      # tmuxPlugins.catppuccin
    ];
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-option -g focus-events on
      set-option -g renumber-windows on

      # manually source catpuccin plugin after options are applied
      set -g @catppuccin_window_tabs_enabled on
      set -g @catppuccin_left_separator "█"
      set -g @catppuccin_right_separator "█"
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded ~/.config/tmux/tmux.conf"
      bind j next-window
      bind k previous-window
      bind h set -g status
      bind e clear-history
      bind t display-popup -E "tms"
    '';
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./nvim/init.lua;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # TODO: find some way to express this as an attrset, and then convert to toml,
  # instead of hand-writing the toml
  home.file.".config/tms/default-config.toml".text = ''
    search_paths = [
        '${config.home.homeDirectory}/code',
        '${config.home.homeDirectory}/work',
        '${config.home.homeDirectory}/personal',
        '${config.home.homeDirectory}/dotfiles',
    ]
  '';
}
