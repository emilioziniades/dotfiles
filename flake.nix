{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let system = "x86_64-darwin"; in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      homeConfigurations = {
        "emilioziniades" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            {
              home = {
                username = "emilioziniades";
                homeDirectory = "/Users/emilioziniades";
                stateVersion = "23.11";
              };
            }
          ];
        };
      };
    };
}
