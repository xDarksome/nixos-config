{
  description = "NixOS configuration flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # cosmic-comp.url = "github:xDarksome/cosmic-comp/updated-upstream";
    # cosmic-comp.inputs.nixpkgs.follows = "nixpkgs";
    # cosmic-launcher.url = "github:xDarksome/cosmic-launcher";
    # psi-shell.url = "github:xDarksome/psi-shell";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, kmonad, home-manager, ... }@inputs: {
    
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [(self: super: import ./pkgs { pkgs = super; })]; }
          { _module.args = inputs; }
          # hyprland.nixosModules.default
          kmonad.nixosModules.default
          { services.kmonad.enable = true;} 
          ./configuration.nix

          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit inputs; };
      };
    };

  };
}
