{...}: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/work.nix
  ];

  home.username = "emilioziniades";
  home.homeDirectory = "/home/emilioziniades";
  home.stateVersion = "24.05";

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;
  ez.programs.kubernetes.enable = false;

  ez.programs.tms = {
    enable = true;
    searchDirs = ["work" "personal" "dotfiles" "dotfiles-secrets"];
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
    dotnet.enable = false;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = false;
    packer.enable = false;
    haskell.enable = false;
    go.enable = false;
    rust.enable = false;
    markdown.enable = true;
    bash.enable = true;
    nushell.enable = false;
  };

  ez.applications.gui.enable = true;
}
