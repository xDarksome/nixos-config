{
  description = "NixOS configuration flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # cosmic-comp.url = "github:xDarksome/cosmic-comp/updated-upstream";
    # cosmic-comp.inputs.nixpkgs.follows = "nixpkgs";
    # cosmic-launcher.url = "github:xDarksome/cosmic-launcher";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, kmonad, home-manager, ... }@inputs: 
  let 
    username = "darksome"; 
  in
  {
    nixosConfigurations = {
      blade15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./razer-blade15.nix ./_pc.nix ];
        specialArgs = { inherit username inputs; hostname = "blade15"; };
      };
    };
  };
}
