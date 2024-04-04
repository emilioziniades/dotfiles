{pkgs, ...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    sandbox = false;
    trusted-users = ["emilioziniades"];
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "nodejs-16.20.2"
    ];
  };
  users.users.emilioziniades.home = "/Users/emilioziniades";

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
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
    ];
  };
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/dotfiles/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  programs.zsh = {
    enable = true;
    promptInit = "";
  };

  system.stateVersion = 4;
}
