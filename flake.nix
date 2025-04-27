{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-cosmic = {
      url = "github:xDarksome/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
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
      x16 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./_x16/mod.nix];
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
