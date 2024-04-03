{
  nix-std,
  catppuccin-alacritty,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings =
      {
        env = {
          TERM = "xterm-256color";
        };
        window.padding = {
          x = 10;
          y = 10;
        };
        font = {
          normal = {
            family = "FiraCode Nerd Font Mono";
            style = "Medium";
          };
          size = 14.0;
        };
        keyboard.bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
          {
            key = "Back";
            mods = "Control";
            chars = "\\u0017"; # delete entire word
          }
        ];
      }
      // nix-std.lib.serde.fromTOML (builtins.readFile "${catppuccin-alacritty}/catppuccin-mocha.toml");
  };
}
