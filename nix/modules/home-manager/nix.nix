{nixpkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  # add current nixpkgs flake input to the registry, so that
  # `nix run nixpkgs#...` doesn't fetch fresh nixpkgs every time
  nix.registry.nixpkgs.flake = nixpkgs;
}
