{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.ez.programs.taskwarrior;
in
{
  options.ez.programs.taskwarrior = with types; {
    enable = mkEnableOption "taskwarrior";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.taskwarrior3
    ];

    xdg.configFile."task/taskrc".text = ''
      news.version=${lib.getVersion pkgs.taskwarrior3}
      data.location=~/.local/share/task
      hooks.location=~/.config/task/hooks

      # custom report to list tasks by project
      report.byproject.description=Tasks grouped by project
      report.byproject.columns=id,project,priority,description
      report.byproject.sort=project+,priority-
      report.byproject.filter=status:pending
    '';

  };
}
