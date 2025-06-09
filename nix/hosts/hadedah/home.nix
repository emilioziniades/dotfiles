{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioziniades";
  home.homeDirectory = "/Users/emilioziniades";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;

  ez.programs.tms = {
    enable = true;
    searchDirs = ["code" "dotfiles" "emilio"];
  };

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
    defaultBranch = "main";
    gpgKey = "877E9B0125E55C17CF2E52DAEA106EB7199A20CA";
  };

  ez.programming = {
    python.enable = true;
    go.enable = true;
    rust.enable = true;
    typescript.enable = false;
    dotnet.enable = true;
    haskell.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = true;
    terraform.enable = false;
    packer.enable = false;
    markdown.enable = true;
    bash.enable = true;
  };

  ez.work.enable = false;

  ez.applications.gui.enable = false;
}
