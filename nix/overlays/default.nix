[
  (final: prev: {
    cw = final.callPackage ../pkgs/cw/package.nix { };
    huaweicloud-cli = final.callPackage ../pkgs/huaweicloud-cli/package.nix { };
  })
  # TODO: watch for issues on nixos github and obsidian discourse and remove when fixed
  (final: prev: {
    obsidian = prev.obsidian.override {
      makeDesktopItem =
        args: final.makeDesktopItem (args // { startupWMClass = "md.obsidian.Obsidian"; });
    };
  })
]
