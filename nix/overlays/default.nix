[
  (import ./obsidian.nix)
  (final: prev: {
    cw = final.callPackage ../pkgs/cw/package.nix { };
  })
]
