{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";

    spectrum-os = {
      url = "git+https://spectrum-os.org/git/spectrum";
      flake = false;
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: super: {
          cloud-hypervisor = import "${inputs.spectrum-os}/pkgs/cloud-hypervisor" {inherit final super;};
        })
      ];
    };

    username = "darksome";

    specialArgs = {
      inherit inputs username vps_ip;
    };
    extraSpecialArgs = specialArgs;
  in {
    nixosConfigurations = {
      x16 = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [./_x16/mod.nix];
      };
    };

    homeConfigurations = {
      x16 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          ./core.nix

          ./sway
          ./wezterm
        ];
      };

      fp5 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          ./core.nix

          ./sway
          ./wezterm
        ];
      };

      pc = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          ./core.nix

          ./sway
          ./wezterm
        ];
      };
    };

    packages.${system} = {
      vps-iso = self.nixosConfigurations.vps.config.system.build.isoImage;
    };
    
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixos-anywhere

        # cloud-hypervisor
        crosvm
        alpine-make-rootfs
        nix-bundle
        pmbootstrap
      ];
    };
  };
}
