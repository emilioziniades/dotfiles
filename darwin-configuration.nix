{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # todo: does this belong in here, or home.nix?
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "nodejs-16.20.1"
    ];
  };
  users.users.emilioziniades.home = "/Users/emilioziniades";

  homebrew = {
    enable = true;
    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
    casks = [
      "discord"
      "firefox"
      "font-fira-code-nerd-font"
      "mactex"
      "multipass"
      "obsidian"
      "openemu"
      "qbittorrent"
      "roboform"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "tor-browser"
      "vlc"
      "whatsapp"
      "zoom"
    ];
  };
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/dotfiles/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
