{
  inputs,
  modulesPath,
  lib,
  pkgs,
  vps_ip,
  ...
} @ args:
{
  imports = [
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.disko.nixosModules.disko
  
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../machine.nix
  ];

  services.tor = {
    enable = true;
    extraConfig = ''
      SocksPort 9050
    '';
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  networking = {
    hostName = "vps";
    useDHCP = lib.mkForce false;

    defaultGateway = {
      address = "82.153.138.1";
      interface = "enp0s18";
    };

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    interfaces.enp0s18 = {
      ipv4.addresses = [{
        address = vps_ip;
        prefixLength = 24;
      }];
    };
  };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  facter.reportPath =
    if builtins.pathExists ./facter.json then
      ./facter.json
    else
      throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";

  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
