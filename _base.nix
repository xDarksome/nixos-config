{
  pkgs,
  inputs,
  hostname,
  username,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./xplr/mod.nix
    ./syncthing/mod.nix
  ];

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.utf8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "unm_US/UTF-8"];
  };

  services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  environment.systemPackages = with pkgs; [
    unixtools.whereis
    wget
    git
    gnupg
    zip
    unzip

    nushell
    helix
    gitui
    bottom
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # The state versions are required and should stay at the version you
  # originally installed.
  system.stateVersion = "22.05";
  home-manager.users.darksome.home.stateVersion = "24.05";
}
