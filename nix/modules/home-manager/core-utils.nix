# TODO: revisiting this, it has code smells...
# it's a lot of different things combined together.. idk
{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    file
    htop
    gnused
    fd
    eza
    bat
    ripgrep
    sd
    fzf
    jq
    ijq
    yq-go
    taplo
    diffutils
    # delta #TODO: uncomment once delta breakage is resolved
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
