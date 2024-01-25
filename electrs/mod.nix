{
  lib,
  pkgs,
  username,
  ...
}: {
  systemd.services.electrs = {
    description = "Electrs daemon";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = username;
      Group = "users";
      ExecStart = "${pkgs.electrs}/bin/electrs";
      Restart = "on-failure";
    };
  };

  home-manager.users.${username}.home.file = {
    ".config/electrs/config.toml".text = ''
      cookie_file = "/home/${username}/.bitcoin/.cookie"
      daemon_rpc_addr = "127.0.0.1:8332"
      daemon_p2p_addr = "127.0.0.1:8333"
      db_dir = "/home/${username}/bitcoin-blockchain/electrs"
      network = "bitcoin"
      electrum_rpc_addr = "127.0.0.1:50001"
      log_filters = "INFO"
    '';
  };
}
