{
  lib,
  pkgs,
  username,
  ...
}: {
  networking.firewall.allowedTCPPorts = [8333];

  systemd.services.bitcoind = {
    description = "Bitcoin daemon";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = username;
      Group = "users";
      ExecStart = "${pkgs.bitcoind}/bin/bitcoind";
      Restart = "on-failure";
    };
  };

  home-manager.users.${username}.home.file = {
    ".bitcoin/bitcoin.conf".text = ''
      server=1
      txindex=1
      prune=0
    '';
  };
}
