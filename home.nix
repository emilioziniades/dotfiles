{
  pkgs,
  emilioExtraConfig,
  ...
}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs;
    [
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
      imagemagick
      postgresql_15
      tor
      pandoc
      nushell
      awscli2
      kubectl
      zip
      unzip
      gnumake
      tmux-sessionizer

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
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      firefox
      obsidian
      mongodb-compass
      remmina
      teams
      spotify
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
      bind t display-popup -E "~/dotfiles/bin/tmux-sessionizer.sh"
    '';
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./nvim/init.lua;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.file."~/.config/tms/default-config.toml".text = ''
    search_paths = [
        '/home/emilioz/code',
        '/home/emilioz/work',
        '/home/emilioz/personal',
        '/home/emilioz/dotfiles',
    ]
  '';
}
