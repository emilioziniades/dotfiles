{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
  ];

  home.packages = with pkgs; [
    postgresql
    glab
    claude-code
    crush
    awscli2
  ];

  home.username = "emilioziniades";
  home.homeDirectory = "/home/emilioziniades";
  home.stateVersion = "24.05";

  age.secrets.gitconfig = {
    file = "${inputs.dotfiles-secrets}/secrets/gitconfig.age";
    path = "${config.xdg.configHome}/git/config.work";
  };

  ez.programs.neovim.enable = true;
  ez.programs.tmux.enable = true;
  ez.programs.wezterm.enable = true;
  ez.programs.kubernetes.enable = true;

  ez.programs.tms = {
    enable = true;
    searchDirs = [
      "Code"
      "dotfiles"
      "dotfiles-secrets"
    ];
  };

  ez.programs.git = {
    enable = true;
    username = "Emilio Ziniades";
    email = "emilioziniades@protonmail.com";
    includes = [
      {
        path = config.age.secrets.gitconfig.path;
        condition = "gitdir:~/Code/Work/";
      }
    ];
  };

  ez.programming = {
    python.enable = true;
    typescript.enable = true;
    dotnet.enable = false;
    lua.enable = true;
    nix.enable = true;
    html.enable = false;
    terraform.enable = true;
    packer.enable = false;
    haskell.enable = false;
    go.enable = true;
    rust.enable = true;
    markdown.enable = true;
    bash.enable = true;
    nushell.enable = false;
    java.enable = true;
    elixir.enable = true;
  };

  ez.applications.gui.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        user = "emilio";
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };

  };
}
