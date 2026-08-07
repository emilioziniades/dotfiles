{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
  ];

  home.packages = with pkgs; [
    firefox
    obsidian
    spotify
    discord
  ];

  home.username = "emilioziniades";
  home.homeDirectory = "/home/emilioziniades";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.ghostty.enable = true;

  ez.programs.tms = {
    enable = true;
    searchDirs = [
      "Code"
      "dotfiles"
      "dotfiles-secrets"
    ];
  };

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
  };

}
