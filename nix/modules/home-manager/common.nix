{
  pkgs,
  inputs,
  ...
}: {
  programs.home-manager.enable = true;

  xdg.enable = true;

  # add current nixpkgs flake input to the registry, so that
  # `nix run nixpkgs#...` doesn't fetch fresh nixpkgs every time
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home.shellAliases = {
    c = "clear && tmux clear-history";
    note = "nvim ~/note.md";
    copy =
      if pkgs.stdenv.isLinux
      then "xclip -selection clipboard"
      else if pkgs.stdenv.isDarwin
      then "pbcopy"
      else null;
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    GPG_TTY = "$(tty)";
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    initContent =
      if pkgs.stdenv.isDarwin
      then ''
        # easier escape key for macbook with touchbar
        bindkey '§' vi-cmd-mode
      ''
      else "";
  };

  programs.starship = {
    enable = true;
    settings = {
      aws.disabled = true;
      shell = {
        disabled = true;
      };
      env_var = {
        disabled = true;
        variable = "STARSHIP_SHELL";
        format = "with [$env_value](blue bold dimmed) ";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    curl
    file
    htop
    gnused
    fd
    eza
    bat
    ripgrep
    tre-command
    sd
    dogdns
    dig
    jq
    ijq
    yq-go
    taplo
    diffutils
    delta
    wget
    gnupg
    zip
    unzip
    gnumake
    gcc
    mktemp
    xclip
    just
    tokei
    hey
    nmap
    watchexec
    timewarrior
    flyctl
    gh
    cook-cli
    imagemagick
    ffmpeg
    pandoc
  ];
}
