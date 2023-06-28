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
      "emilioziniades" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-darwin";
        homeDirectory = "/Users/emilioziniades";
        username = "emilioziniades";
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}
