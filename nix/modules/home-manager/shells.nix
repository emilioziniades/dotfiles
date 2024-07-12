{pkgs, ...}: {
  home.shellAliases = {
    t = "tmux";
    c = "clear && tmux clear-history";
    k = "kubectl";
    copy =
      if pkgs.stdenv.isLinux
      then "xclip -selection clipboard"
      else if pkgs.stdenv.isDarwin
      then "pbcopy"
      else null;
    ls = "eza";
    cat = "bat";
    tree = "eza --tree --git-ignore";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LC_ALL = "en_US.UTF-8";
    GPG_TTY = "$(tty)";
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    # TODO: Figure out the default readline(well, zle) keybindings for this and use these instead
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

  home.packages = with pkgs; [
    bash-language-server
  ];
}
