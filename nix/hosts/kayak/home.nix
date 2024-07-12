{pkgs, ...}: {
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioz";
  home.homeDirectory = "/home/emilioz";
  home.stateVersion = "24.05";

  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override {fonts = ["Monaspace"];})
  ];

  # TODO: only do this when we are not on nixos (how do we differentiate between nixos and non-nixos linux?)
  targets.genericLinux.enable = true;

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;
  ez.programs.tms.enable = true;

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioz@za.velocitytrade.com";
    defaultBranch = "master";
  };

  ez.programming-languages = {
    python.enable = true;
    typescript.enable = true;
    dotnet.enable = false;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = true;
    packer.enable = false;
    haskell.enable = false;
    go.enable = false;
    rust.enable = false;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = true;
}
