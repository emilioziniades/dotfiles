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
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]
      (system: fn system nixpkgs.legacyPackages.${system});
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
        # TODO: Track https://github.com/NixOS/nixpkgs/issues/315574 and remove this
        # inline module when there are updates there.
        (
          /*
          Last reviewied: 2024-05-29

          fixes issues with lack of HTTP header sanitization in .NET Core, see:
          - https://github.com/NixOS/nixpkgs/issues/315574
          - https://github.com/microsoftgraph/msgraph-cli/issues/477
          */
          {
            lib,
            options,
            ...
          }: {
            /*
            using just `readOnly` because it can contain neither of: default, example, description, apply, type
            see https://github.com/NixOS/nixpkgs/blob/aae38d0d557d2f0e65b2ea8e1b92219f2c0ea8f9/lib/modules.nix#L752-L756
            */
            options.system.nixos.codeName = lib.mkOption {readOnly = false;};
            config.system.nixos.codeName = let
              codeName = options.system.nixos.codeName.default;
              renames."Vicuña" = "Vicuna";
            in
              renames."${codeName}" or (throw "Unknown `codeName`: ${codeName}, please add it to `renames` in `ascii-workaround.nix`");
          }
        )
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
            inherit catppuccin-alacritty nix-std dotfiles-secrets;
          };
          home-manager.sharedModules = [agenix.homeManagerModules.default];
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
