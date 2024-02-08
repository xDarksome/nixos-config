{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # cosmic-comp.url = "github:xDarksome/cosmic-comp/updated-upstream";
    # cosmic-comp.inputs.nixpkgs.follows = "nixpkgs";
    # cosmic-launcher.url = "github:xDarksome/cosmic-launcher";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";

    xremap-flake.url = "github:xremap/nix-flake";
    xremap-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    username = "darksome";
  in {
    nixosConfigurations = {
      blade15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./_blade15/mod.nix];
        specialArgs = {
          inherit username inputs;
        };
      };

      vps0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./_vps0/mod.nix];
        specialArgs = {
          inherit username inputs;
        };
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
