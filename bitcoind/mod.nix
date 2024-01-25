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
      blocksdir=/home/${username}/bitcoin-blockchain
      server=1
      txindex=0
      prune=0
      dbcache=2048
    '';
  };
}
