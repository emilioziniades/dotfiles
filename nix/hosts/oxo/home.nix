{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioz";
  home.homeDirectory = "/home/emilioz";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
  };

  ez.programming.nix.enable = true;
}
