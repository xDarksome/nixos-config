{
  pkgs,
  username,
  ...
}: {
  imports = [./hardware-configuration.nix ../vps.nix ../bitcoind/mod.nix ../electrs/mod.nix];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking.hostName = "vps0";
  networking.interfaces.ens18 = {
    ipv4.addresses = [
      {
        address = "82.153.138.51";
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = "82.153.138.1";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [443];
  };

  environment.systemPackages = with pkgs; [electrs];
}
