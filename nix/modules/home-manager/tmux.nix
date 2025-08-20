{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.ez.programs.tmux;
in
{
  options.ez.programs.tmux.enable = mkEnableOption "tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      keyMode = "vi";
      terminal = "tmux-256color";
      historyLimit = 100000;
      escapeTime = 10;
      sensibleOnTop = false;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor "macchiato"
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_text " #W"
            set -g @catppuccin_window_current_text " #W"
            set -g status-right "#{E:@catppuccin_status_session}"
            set -g status-left ""
          '';
        }
      ];
      extraConfig = ''
        set -ag terminal-overrides ",xterm-256color:RGB"
        # see here for below voodoo: https://github.com/tmux/tmux/issues/1202
        set -as terminal-overrides ',xterm*:sitm=\E[3m'
        set-option -g focus-events on
        set-option -g renumber-windows on

        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded ~/.config/tmux/tmux.conf"
        bind j next-window
        bind k previous-window
        bind h set -g status
        bind t display-popup -E "tms"

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
  };
}
