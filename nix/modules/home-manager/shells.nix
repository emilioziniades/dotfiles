{pkgs, ...}: {
  home.shellAliases = {
    c = "clear && tmux clear-history";
    copy =
      if pkgs.stdenv.isLinux
      then "xclip -selection clipboard"
      else if pkgs.stdenv.isDarwin
      then "pbcopy"
      else null;
    ls = "eza";
    cat = "bat";
    find = "fd";
    grep = "rg";
    # TODO: this is derivable from OS type + home username + dir
    switch =
      if pkgs.stdenv.isLinux
      then "sudo -u $USER nixos-rebuild switch --flake $HOME/dotfiles"
      else if pkgs.stdenv.isDarwin
      then "darwin-rebuild switch --flake $HOME/dotfiles"
      else null;
  };

  # for profiling zsh startup times, see: https://esham.io/2018/02/zsh-profiling
  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
      # TODO: these two dotnet things should go into its own module
      DOTNET_CLI_TELEMETRY_OPTOUT = 1;
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
      GPG_TTY = "$(tty)";
    };
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
