{
  description = "John's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations."Emilios-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./configuration.nix ];
    };
  };
}
