{ pkgs, ... }:
{
  system.primaryUser = "emilioziniades";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    sandbox = false;
    trusted-users = [ "@admin" ];
  };

  nix.linux-builder.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
  };

  users.users.emilioziniades.home = "/Users/emilioziniades";

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  homebrew = {
    enable = true;
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];
    casks = [
      "discord"
      "firefox"
      "mactex"
      "multipass"
      "obsidian"
      "openemu"
      "qbittorrent"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "tor-browser"
      "vlc"
      "whatsapp"
      "zoom"
      "balenaetcher"
    ];
  };

  environment.darwinConfig = "$HOME/dotfiles/configuration.nix";

  programs.zsh = {
    enable = true;
    promptInit = "";
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.stateVersion = 6;
}
