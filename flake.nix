#TODO: refactor away all the inline modules
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-std = {
      url = "github:chessai/nix-std";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
    };

    sentinelone = {
      url = "github:devusb/sentinelone.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles-secrets = {
      url = "git+ssh://git@github.com/emilioziniades/dotfiles-secrets.git";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    nix-std,
    agenix,
    dotfiles-secrets,
    disko,
    sentinelone,
    ...
  }: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]
      (system: fn system nixpkgs.legacyPackages.${system});
  in {
    nixosConfigurations.kayak = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/hosts/kayak/configuration.nix
        home-manager.nixosModules.home-manager
        sentinelone.nixosModules.sentinelone
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.emilioz = import ./nix/hosts/kayak/home.nix;
            extraSpecialArgs = {
              inherit nixpkgs nix-std dotfiles-secrets;
            };
            sharedModules = [agenix.homeManagerModules.default];
          };
        }
      ];
    };

    homeConfigurations.emilioz = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/hosts/kayak/home.nix
        ];
        extraSpecialArgs = {
          inherit nixpkgs nix-std dotfiles-secrets;
        };
      };

    darwinConfigurations.hadedah = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./nix/hosts/hadedah/darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.emilioziniades = import ./nix/hosts/hadedah/home.nix;
            extraSpecialArgs = {
              inherit nixpkgs nix-std dotfiles-secrets;
            };
            sharedModules = [agenix.homeManagerModules.default];
          };
        }
      ];
    };

    nixosConfigurations.oxo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/hosts/oxo/configuration.nix
        ./nix/hosts/oxo/disko-configuration.nix
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {
            inherit nixpkgs nix-std dotfiles-secrets;
          };
        }
      ];
    };

    devShells = forAllSystems (system: pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          neovim
          git
          curl
        ];
      };
    });
  };
}
