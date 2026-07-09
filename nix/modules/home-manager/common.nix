{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.home-manager.enable = true;

  xdg.enable = true;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home.shellAliases = {
    c = "clear && tmux clear-history";
    copy =
      if pkgs.stdenv.isLinux then
        "xclip -selection clipboard"
      else if pkgs.stdenv.isDarwin then
        "pbcopy"
      else
        null;
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    GPG_TTY = "$(tty)";
  };

  programs.zsh = {
    dotDir = "${config.xdg.configHome}/zsh";
    enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    initContent = ''
      # open the current command in $EDITOR with ctrl-e
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^e' edit-command-line
    ''
    + (
      if pkgs.stdenv.isDarwin then
        ''
          # easier escape key for macbook with touchbar
          bindkey '§' vi-cmd-mode
        ''
      else
        ""
    );
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$character";
      git_branch.format = "[$branch]($style) ";
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
    unixtools.net-tools
    gh
    cook-cli
    # imagemagick
    # ffmpeg
    # pandoc
    inetutils
    certigo
    dotenvy
  ];
}
