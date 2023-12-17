{pkgs, ...}: {
  imports = [./hardware-configuration.nix ../vps.nix];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
}
