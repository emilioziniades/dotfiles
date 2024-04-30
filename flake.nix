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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
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
    catppuccin-alacritty,
    dotfiles-secrets,
    ...
  }: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
      ] (
        system: fn nixpkgs.legacyPackages.${system}
      );
  in {
    nixosConfigurations.kayak = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/hosts/kayak/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.emilioz = import ./nix/hosts/kayak/home.nix;
          home-manager.extraSpecialArgs = {
            inherit catppuccin-alacritty nix-std dotfiles-secrets;
          };
          home-manager.sharedModules = [agenix.homeManagerModules.default];
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
          home-manager.sharedModules = [agenix.homeManagerModules.default];
        }
      ];
    };

    devShell = forAllSystems (pkgs:
      pkgs.mkShell {
        buildInputs = with pkgs; [
          neovim
          git
          curl
        ];
      });
  };
}
