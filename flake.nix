{
  description = "Emilio's nix configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-std = {
      url = "github:chessai/nix-std";
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    nix-std,
    catppuccin-alacritty,
    ...
  }: {
    # TODO: change hostname to kayak
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/hosts/kayak/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioz = import ./nix/hosts/kayak/home.nix;
          home-manager.extraSpecialArgs = {
            inherit catppuccin-alacritty nix-std;
          };
        }
      ];
    };

    darwinConfigurations.hadedah = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./nix/hosts/hadedah/darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioziniades = import ./nix/hosts/hadedah/home.nix;
          home-manager.extraSpecialArgs = {
            inherit catppuccin-alacritty nix-std;
          };
        }
      ];
    };
  };
}
