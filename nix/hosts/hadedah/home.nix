{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioziniades";
  home.homeDirectory = "/Users/emilioziniades";
  home.stateVersion = "24.05";

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
    defaultBranch = "main";
    gpgKey = "877E9B0125E55C17CF2E52DAEA106EB7199A20CA";
  };

  ez.programming-languages = {
    python.enable = true;
    go.enable = true;
    rust.enable = true;
    typescript.enable = true;
    dotnet.enable = true;
    haskell.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = true;
    terraform.enable = false;
    packer.enable = false;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = false;
}
