{pkgs, ...}: {
  home.shellAliases = {
    c = "clear && tmux clear-history";
    v = "nvim";
    t = "tmux";
    k = "kubectl";
    copy =
      if pkgs.stdenv.isLinux
      then "xclip -selection clipboard"
      else if pkgs.stdenv.isDarwin
      then "pbcopy"
      else null;
    ls = "eza";
    cat = "bat";
    switch =
      if pkgs.stdenv.isLinux
      # TODO: this doesn't have syntax highlighting and it's annoying
      then "sudo --user $USER nixos-rebuild switch --flake $HOME/dotfiles"
      else if pkgs.stdenv.isDarwin
      then "darwin-rebuild switch --flake $HOME/dotfiles"
      else null;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    GPG_TTY = "$(tty)";
  };

  # for profiling zsh startup times, see: https://esham.io/2018/02/zsh-profiling
  programs.zsh = {
    enable = true;
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

  xdg.enable = true;
}
