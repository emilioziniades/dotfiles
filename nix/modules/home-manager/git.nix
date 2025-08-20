{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ez.programs.git;
in
{
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
    includes = mkOption {
      type = listOf attrs;
      default = [ ];
    };
  };

  # NOTE: See https://blog.gitbutler.com/how-git-core-devs-configure-git/ for explanations of some of the below options

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
        sync = "!git switch master && git pull";
      };
      includes = cfg.includes;
      extraConfig = {
        user.signingkey = cfg.gpgKey;
        init.defaultBranch = cfg.defaultBranch;
        core.editor = "nvim";
        commit.gpgsign = false;
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        pull.rebase = false;
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          renames = true;
          mnemonicPrefix = true;
        };
        rebase = {
          autoSquash = true;
          updateRefs = true;
        };
      };

      delta.enable = true;
    };
  };
}
