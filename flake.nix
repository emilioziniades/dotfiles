{
  description = "Emilio's nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-std.url = "github:chessai/nix-std";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    nix-std,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioz = import ./nix/home.nix;
          home-manager.extraSpecialArgs = {
            std = nix-std;
            emilioExtraConfig = {
              username = "emilioz";
              homeDirectory = "/home/emilioz";
              gitEmail = "emilioz@za.velocitytrade.com";
              gitDefaultBranch = "master";
              gitGpgKey = false;
              switchCommand = "sudo -u $USER nixos-rebuild switch --flake $HOME/dotfiles";
            };
          };
        }
      ];
    };

    darwinConfigurations."Emilios-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./nix/darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioziniades = import ./nix/home.nix;
          home-manager.extraSpecialArgs = {
            std = nix-std;
            emilioExtraConfig = {
              username = "emilioziniades";
              homeDirectory = "/Users/emilioziniades";
              gitEmail = "emilioziniades@protonmail.com";
              gitDefaultBranch = "main";
              gitGpgKey = "877E9B0125E55C17CF2E52DAEA106EB7199A20CA";
              switchCommand = "darwin-rebuild switch --flake $HOME/dotfiles";
            };
          };
        }
      ];
    };

    homeConfigurations."emilioziniades" = home-manager.lib.homeManagerConfiguration {
      modules = [./nix/home.nix];
      extraSpecialArgs = {
        emilioExtraConfig = {
          username = "emilioziniades";
          homeDirectory = "/home/emilioziniades";
          gitEmail = "emilioz@za.velocitytrade.com";
          gitDefaultBranch = "master";
          gitGpgKey = false;
          switchCommand = "home-manager switch --flake $HOME/dotfiles";
        };
      };
    };
  };
}
