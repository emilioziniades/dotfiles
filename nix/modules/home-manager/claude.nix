{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.ez.programs.claude;

  claude-icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/lobehub/lobe-icons/refs/heads/master/packages/static-svg/icons/claudecode-color.svg";
    sha256 = "0zw7d81xgbm884skyh0rrd9j0pnba6fsaqkyiynia24xfj6ks2v7";
  };

  claude-notify =
    with pkgs;
    symlinkJoin rec {
      name = "claude-notify";
      paths = [ script ] ++ buildInputs;
      postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      buildInputs = [
        jq
        libnotify
        tmux
      ];
      nativeBuildInputs = [ makeWrapper ];

      script = pkgs.writeScriptBin name ''
        msg=$(jq -r '.message // "Claude Code"')

        if [ -n "$TMUX_PANE" ]; then
            title=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name} [#{window_index}]' 2>/dev/null)
        fi
        if [ -z "$title" ]; then
            title="Terminal"
        fi

        notify-send --app-name "Claude Code" --icon "${claude-icon}" "$title" "$msg"
      '';

    };
in
{
  options.ez.programs.claude.enable = mkEnableOption "claude code";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.claude-code ];

    home.file.".claude/settings.json".text = builtins.toJSON {
      model = "opus[1m]";
      alwaysThinkingEnabled = true;
      effortLevel = "medium";
      editorMode = "vim";
      skipDangerousModePermissionPrompt = true;
      hooks = {
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = "${claude-notify}/bin/claude-notify";
              }
            ];
          }
        ];
      };
    };
  };
}
