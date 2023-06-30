{pkgs, ...}: {
  programs.home-manager.enable = true;
  home.packages = [
    pkgs.alacritty
    pkgs.tmux
    pkgs.htop
    pkgs.fd
    pkgs.fzf
    pkgs.tree
    pkgs.ripgrep
    pkgs.jq
    pkgs.diffutils
    pkgs.wget
    pkgs.flyctl
    pkgs.gh
    pkgs.alejandra
  ];

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
    extraConfig = builtins.readFile ./tmux/tmux.conf;
  };
}
