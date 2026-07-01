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
    programs.claude-code = {
      enable = true;
      settings = {
        model = "opus[1m]";
        alwaysThinkingEnabled = true;
        effortLevel = "medium";
        editorMode = "vim";
        skipDangerousModePermissionPrompt = true;
        hooks.Notification = [
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

      context = ''
        # Coding style

        DO use common libraries instead of rolling it yourself.
        DO prefer functional programming patterns over OOP.
        DO use type hints and annotations in dynamic languages when possible.
        DO use `nix run nixpkgs#...` to run a program that isn't installed.
        DO use `uv` for all python work, with single-file uv script dependencies.

        DO NOT use comments without a particularly good reason.
        DO NOT embed Python commands inside bash scripts.

        # Workflow

        DO test changes locally as best as you can.
        DO use the internet to look up documentation.
        DO verify claims against the source.

        DO NOT guess.
        DO NOT echo context markers into ssh commands.

        # Communication

        DO use a concise, professional tone when communicating.

        DO NOT write overly verbose responses with unnecessary details.

        # Git

        DO NOT run state-modifying git commands.
        DO NOT add yourself as a coauthor on any commits.
        DO NOT use emojis in commit messages.
        DO NOT push commits.
      '';
    };
  };
}
