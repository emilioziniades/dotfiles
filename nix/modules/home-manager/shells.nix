# TODO: revisit this, it has code smells...
# it's a lot of different things combined together.. idk
{pkgs, ...}: {
  home.shellAliases = {
    c = "clear && tmux clear-history";
    k = "kubectl";
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
    initExtra =
      if pkgs.stdenv.isDarwin
      then ''
        # easier escape key for macbook with touchbar
        bindkey '§' vi-cmd-mode
      ''
      else "";
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
