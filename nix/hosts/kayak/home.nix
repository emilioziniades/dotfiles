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

  ez.programs = {
    rust.enable = true;
    python.enable = true;
    go.enable = true;
    dotnet.enable = true;
    haskell.enable = true;
    lua.enable = true;
    nix.enable = true;
    infrastructure-as-code.enable = true;
    webdev.enable = true;
  };

  ez.dev.velocity-trade.enable = true;

  ez.applications.gui.enable = false;
}
