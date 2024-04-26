{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    file
    htop
    fd
    eza
    bat
    tree
    ripgrep
    sd
    fzf
    jq
    ijq
    yq-go
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
    nushell
    watchexec
    timewarrior
    flyctl
    gh
    postgresql_15
    pgformatter
    cook-cli
    imagemagick
    ffmpeg
    pandoc
    shfmt
    shellcheck
  ];

  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
