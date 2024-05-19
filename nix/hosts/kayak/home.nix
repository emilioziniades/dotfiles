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
    go.enable = true;
    rust.enable = true;
    typescript.enable = true;
    dotnet.enable = true;
    haskell.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = true;
    terraform.enable = true;
    packer.enable = true;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = true;
}
