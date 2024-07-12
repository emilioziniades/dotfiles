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
    switch =
      if pkgs.stdenv.isLinux
      then "home-manager switch --flake $HOME/dotfiles"
      # NOTE: below is for nixos machines, but my current machine is Debian
      # then "sudo --user $USER nixos-rebuild switch --flake $HOME/dotfiles"
      else if pkgs.stdenv.isDarwin
      then "darwin-rebuild switch --flake $HOME/dotfiles"
      else null;
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
