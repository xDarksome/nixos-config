{
  lib,
  pkgs,
  username,
  ...
}: {
  services.monero = {
    enable = true;
    extraConfig = ''
      no-igd=1
    '';
  };

  services.tor = {
    enable = true;
    settings = {
      HiddenServiceDir = "/var/lib/tor/monero-service/";
      HiddenServicePort = "18081 127.0.0.1:18081";
    };
  };

  environment.systemPackages = with pkgs; [monero-gui];
}
