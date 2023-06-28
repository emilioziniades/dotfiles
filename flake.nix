{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs = {
        url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;
    defaultPackage.x86_64-darwin = inputs.home-manager.defaultPackage.x86_64-darwin;
 
    homeConfigurations = {
        "emilioziniades" = let system = "x86_64-darwin"; in inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.${system};
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
