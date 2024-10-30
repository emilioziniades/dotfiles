{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioz";
  home.homeDirectory = "/home/emilioz";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;

  ez.programs.tms = {
    enable = true;
    searchDirs = ["work" "personal" "dotfiles" "obsidian"];
  };

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioz@za.velocitytrade.com";
    defaultBranch = "master";
  };

  ez.programming = {
    python.enable = true;
    typescript.enable = true;
    dotnet.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = true;
    packer.enable = false;
    haskell.enable = false;
    go.enable = false;
    rust.enable = false;
    markdown.enable = true;
    bash.enable = true;
    nushell.enable = true;
  };

  ez.vt.enable = true;

  ez.applications.gui.enable = true;
}
