{
  pkgs,
  config,
  std,
  emilioExtraConfig,
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
      hey
      nmap
      nushell
      # TODO: delete local copy once upstream is updated
      # tmux-sessionizer
      (pkgs.callPackage ./pkgs/tmux-sessionizer/package.nix {Security = darwin.apple_sdk.frameworks.Security;})
      watchexec
      timewarrior
      flyctl
      gh
      # TODO: uncomment once upstream build issues are resolved: https://nixpk.gs/pr-tracker.html?pr=296007
      # awscli2
      kubectl
      postgresql_15
      pgformatter
      cook-cli
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
      (pkgs.callPackage ./pkgs/dotnet-outdated/package.nix {})
      (pkgs.callPackage ./pkgs/dotnet-repl/package.nix {})

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

  programs.git = {
    enable = true;
    userName = "Emilio Ziniades";
    userEmail = emilioExtraConfig.git.email;
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
        signingkey = emilioExtraConfig.git.gpgKey;
      };
      init = {
        defaultBranch = emilioExtraConfig.git.defaultBranch;
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

  programs.alacritty = let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "alacritty";
      rev = "main";
      hash = "sha256-HiIYxTlif5Lbl9BAvPsnXp8WAexL8YuohMDd/eCJVQ8=";
    };
  in {
    enable = true;
    settings =
      {
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
        keyboard.bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
          {
            key = "Back";
            mods = "Control";
            chars = "\\u0017"; # delete entire word
          }
        ];
      }
      // std.lib.serde.fromTOML (builtins.readFile "${catppuccin}/catppuccin-mocha.toml");
  };

  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 100000;
    escapeTime = 10;
    sensibleOnTop = false;
    plugins = [];
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      # see here for below voodoo: https://github.com/tmux/tmux/issues/1202
      set -as terminal-overrides ',xterm*:sitm=\E[3m'
      set-option -g focus-events on
      set-option -g renumber-windows on

      # manually source catppuccin plugin after options are applied
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

  home.file.".config/tms/config.toml".text = std.lib.serde.toTOML {
    search_dirs = [
      {
        path = "${config.home.homeDirectory}/code";
        depth = 2;
      }
      {
        path = "${config.home.homeDirectory}/work";
        depth = 2;
      }
      {
        path = "${config.home.homeDirectory}/personal";
        depth = 2;
      }
      {
        path = "${config.home.homeDirectory}/dotfiles";
        depth = 1;
      }
    ];
  };
}
