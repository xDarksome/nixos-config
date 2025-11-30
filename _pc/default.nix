{
  pkgs,
  config,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
    ../machine.nix
    ../mullvad-vpn
    ../cosmic/mod.nix
  ];

  networking.hostName = "pc";

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
    mullvad-vpn
  ];
}
