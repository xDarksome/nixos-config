{
  pkgs,
  inputs,
  username,
  overlayPkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./nushell/mod.nix
    ./git/mod.nix
    ./gitui/mod.nix
    ./helix/mod.nix
    ./xplr/mod.nix
  ];

  # networking.networkmanager.enable = true;
  # networking.wireless.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBJcLJ7ZGkut93mp+aAdn3NQVmV3oWIE4xQLcZo3mkl"
    ];
  };

  environment.systemPackages = with pkgs; [
    zoxide

    unixtools.whereis
    wget
    zip
    unzip

    gnupg
    gpg-tui
    pinentry-curses

    dua

    btop
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
