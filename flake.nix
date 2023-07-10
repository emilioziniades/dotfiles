{
  description = "Emilio's NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    darwin.url = github:lnl7/nix-darwin/master;
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    openfortivpn-cli.url = github:emilioziniades/openfortivpn-cli;
    openfortivpn-cli.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    darwin,
    nixpkgs,
    home-manager,
    openfortivpn-cli,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioz = import ./home.nix;
          home-manager.extraSpecialArgs = {
            emilioExtraConfig = {
              gitEmail = "emilioz@za.velocitytrade.com";
              gitGpgKey = false;
              switchCommand = "sudo nixos-rebuild switch --flake $HOME/dotfiles";
            };
            openfortivpn-cli = openfortivpn-cli.defaultPackage.${system};
          };
        }
      ];
    };

    darwinConfigurations."Emilios-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioziniades = import ./home.nix;
          home-manager.extraSpecialArgs = {
            emilioExtraConfig = {
              gitEmail = "emilioziniades@protonmail.com";
              gitGpgKey = "877E9B0125E55C17CF2E52DAEA106EB7199A20CA";
              switchCommand = "darwin-rebuild switch --flake $HOME/dotfiles";
            };
          };
        }
      ];
    };
  };
}
