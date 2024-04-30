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

  ez.programs = {
    rust.enable = true;
    python.enable = true;
    go.enable = true;
    dotnet.enable = true;
    haskell.enable = true;
    lua.enable = true;
    nix.enable = true;
    infrastructure-as-code.enable = false;
    webdev.enable = true;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = false;
}
