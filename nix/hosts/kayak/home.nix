{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioz";
  home.homeDirectory = "/home/emilioz";
  home.stateVersion = "24.05";

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioz@za.velocitytrade.com";
    defaultBranch = "master";
  };

  ez.programming-languages = {
    python.enable = true;
    typescript.enable = true;
    dotnet.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = false;
    packer.enable = false;
    haskell.enable = false;
    go.enable = false;
    rust.enable = false;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = true;
}
