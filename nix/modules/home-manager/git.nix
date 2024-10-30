{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.ez.programs.git;
in {
  options.ez.programs.git = with types; {
    enable = mkEnableOption "git";
    email = mkOption {
      type = str;
    };
    username = mkOption {
      type = str;
    };
    gpgKey = mkOption {
      type = either str bool;
      default = false;
    };
    defaultBranch = mkOption {
      type = str;
      default = "main";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.username;
      userEmail = cfg.email;
      aliases = {
        s = "status";
        d = "diff";
        l = "log --oneline --all";
        g = "log --oneline --graph --decorate --all";
      };
      extraConfig = {
        user.signingkey = cfg.gpgKey;
        init.defaultBranch = cfg.defaultBranch;
        core.editor = "nvim";
        commit.gpgsign = false;
        push.autoSetupRemote = true;
        pull.rebase = false;
        rerere.enabled = true;
      };

      delta.enable = true;
    };
  };
}
