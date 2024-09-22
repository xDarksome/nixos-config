{
  lib,
  pkgs,
  username,
  ...
}: {
  services.monero = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [monero-gui];
}
