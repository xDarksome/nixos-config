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

    microvm = {
      url = "github:xDarksome/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
    vps_ip = "82.153.138.117";

    specialArgs = {
      inherit inputs username vps_ip;
    };
  in {
    nixosConfigurations = {
      x16 = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [./_x16/mod.nix];
      };

      pc = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [./_pc];
      };

      # nixos-anywhere --flake .#generic-nixos-facter --generate-hardware-config nixos-facter _vps/facter.json <hostname>
      vps = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [./_vps];
      }; 

      # my-microvm = nixpkgs.lib.nixosSystem {
      #   inherit system specialArgs;

      #   modules = [
      #     inputs.microvm.nixosModules.microvm
      #     ./vm.nix
      #   ];

      #   specialArgs = {
      #     inherit username system inputs;
      #   };
      # };
    };

    packages.${system} = {
      my-microvm = self.nixosConfigurations.my-microvm.config.microvm.declaredRunner;
      vps-iso = self.nixosConfigurations.vps.config.system.build.isoImage;
    };
    
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [nixos-anywhere


    (writeShellApplication {
      name = "deploy-vps";
      text = ''nu ${./deploy-vps.nu} ${username} ${vps_ip} "$@"'';
    })

      ];
    };
  };
}
