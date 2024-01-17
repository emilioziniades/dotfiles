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
  };

  imports = [];

  home.packages = with pkgs;
    [
      # GENERAL TOOLS
      curl
      htop
      fd
      eza
      bat
      tree
      ripgrep
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
      (pkgs.callPackage ./pkgs/vt-cli/package.nix {pythonPackages = python3.pkgs;})
      (pkgs.callPackage ./pkgs/vpn/package.nix {})
      # imagemagick
      # ffmpeg
      # tor
      # pandoc

      # SHELL
      shfmt
      shellcheck

      # NIX
      alejandra
      manix

      # RUST
      cargo
      rustc
      rustfmt
      rust-analyzer

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
          sdk_7_0
        ])
      csharp-ls
      (pkgs.callPackage ./pkgs/vpn/package.nix {}) # TODO: use upstream once merged: https://github.com/NixOS/nixpkgs/pull/272806
      netcoredbg

      # IAC
      packer
      terraform
      terraform-ls

      # HASKELL
      ghc
      haskell-language-server
      haskellPackages.stack
      haskellPackages.fourmolu
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # firefox
      # obsidian
      # mongodb-compass
      # redisinsight
      # remmina
      # teams
      # spotify
      # element-desktop
      # discord
      # etcher
    ];

  programs.home-manager.enable = true;

  home.shellAliases = {
    v = "nvim";
    t = "tmux";
    k = "kubectl";
    c = "clear && tmux clear-history";
    ll = "ls -alh --color=always";
    copy = "xclip -selection clipboard";
    ls = "eza";
    cat = "bat";
    find = "fd";
    switch = emilioExtraConfig.switchCommand;
  };

  programs.zsh = {
    enable = true;
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
    syntaxHighlighting.enable = true;
    initExtra = ''
      # if you want to profile zsh startup times, see: https://esham.io/2018/02/zsh-profiling

      PROMPT='%F{yellow}%~%f %F{blue}%#%f '

      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      export GPG_TTY=$(tty)

      export GOPATH=$HOME/go/bin
      export PATH="$GOPATH:$PATH"

      export DOTNET_ROOT=$HOME/.dotnet
      export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
      export DOTNET_CLI_TELEMETRY_OPTOUT=1

      [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      yellow=$(tput setaf 3)
      blue=$(tput setaf 4)
      reset=$(tput sgr0)
      PS1='\[$yellow\]\w\[$reset\] \[$blue\]$\[$reset\] '
    '';
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
        defaultBranch = emilioExtraConfig.gitDefaultBranch;
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
      pull = {
        rebase = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      import = ["~/dotfiles/colours/catppuccin/alacritty/catppuccin-mocha.toml"];
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
      # see here for below voodoo: https://github.com/tmux/tmux/issues/1202
      set -as terminal-overrides ',xterm*:sitm=\E[3m'
      set-option -g focus-events on
      set-option -g renumber-windows on

      # manually source catpuccin plugin after options are applied
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_text "#W"
      set -g @catppuccin_window_left_separator "█"
      set -g @catppuccin_window_right_separator "█"
      set -g @catppuccin_status_left_separator "█"
      set -g @catppuccin_status_right_separator "█"
      set -g @catppuccin_status_modules "session"
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
    extraLuaConfig = builtins.readFile ../nvim/init.lua;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # TODO: find some way to express this as an attrset, and then convert to toml,
  # instead of hand-writing the toml
  home.file.${
    if pkgs.stdenv.isDarwin
    then "/Library/Application Support/rs.tms/default-config.toml"
    else ".config/tms/default-config.toml"
  }.text = ''
    search_paths = []

    [[search_dirs]]
    path = '${config.home.homeDirectory}/code'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/work'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/personal'
    depth = 10

    [[search_dirs]]
    path = '${config.home.homeDirectory}/dotfiles'
    depth = 10
  '';
}
