{
  pkgs,
  config,
  ...
}: {
  sops.secrets.mullvad-vpn-wg-quick = {
    sopsFile = ./wg-quick.conf;
    format = "binary";
  };

  # networking.wg-quick.interfaces.mullvad-vpn = {
  #   configFile = config.sops.secrets."mullvad-vpn-wg-quick".path;
  # };
}
