[
  (import ./obsidian.nix)
  (final: prev: {
    cw = final.callPackage ../pkgs/cw/package.nix { };
    huaweicloud-cli = final.callPackage ../pkgs/huaweicloud-cli/package.nix { };
  })
]
