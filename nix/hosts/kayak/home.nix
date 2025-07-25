{...}: {
  imports = [
    ../../modules/home-manager
  ];

  home.username = "emilioz";
  home.homeDirectory = "/home/emilioz";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;
  ez.programs.kubernetes.enable = true;

  ez.programs.tms = {
    enable = true;
    searchDirs = ["work" "personal" "dotfiles" "dotfiles-secrets" "obsidian"];
  };

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
    defaultBranch = "master";
  };

  ez.programming = {
    python.enable = true;
    typescript.enable = true;
    dotnet.enable = true;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = false;
    packer.enable = false;
    haskell.enable = false;
    go.enable = true;
    rust.enable = false;
    markdown.enable = true;
    bash.enable = true;
    nushell.enable = true;
  };

  ez.applications.gui.enable = true;
}
