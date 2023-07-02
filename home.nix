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
    # CLI tools
    alacritty
    tmux
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
    # GUI apps
    #TODO: get this working on darwin
    # discord #TODO: find better way to manage nix + nixpkgs config, nix-darwin maybe?
    # firefox-bin
    # vlc
    # Nix
    alejandra
    # Go
    go
    gopls
    gotools
    # Python
    (python311.withPackages
      (p: [
        p.ipython
        p.requests
        p.numpy
        p.pandas
        p.seaborn
      ]))
    # Lua
    lua
    stylua
    lua-language-server
    # C
    gcc11
    # JavaScript/TypeScript
    nodejs_16
    nodePackages.pyright
  ];

  programs.home-manager = {
    enable = true;
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
    extraConfig = builtins.readFile ./tmux/tmux.conf; # TODO, flatten this into single directory
  };
}
