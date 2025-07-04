{
  lib,
  config,
  inputs,
  pkgs,
  username,
  appimageTools,
  ...
}: {
  imports = [
    ./machine.nix

    inputs.microvm.nixosModules.host
    ./sops

    ./kanata/mod.nix
    ./wezterm/mod.nix
    ./sway/mod.nix

    ./nix-bitcoin/mod.nix
    ./monero/mod.nix

    ./glance

    ./qbittorrent

    ./cosmic/mod.nix

    ./chromium

    ./mpv

    ./syncthing/mod.nix
  ];

  boot.supportedFilesystems = ["ntfs"];
  boot.kernelModules = ["i2c-dev"];

  services.tor = {
    # enable = true;
    # settings = {
    #   HiddenServiceDir = "/var/lib/tor/test-service/";
    #   HiddenServicePort = "3000 127.0.0.1:3000";
    # };
    
    relay.onionServices.test = {
      path = "/var/lib/tor/test-service/";
      map = [3000];
    };
  };

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udev.packages = with pkgs; [
      qmk-udev-rules
      android-udev-rules
    ];
    udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="plugdev", MODE="0666", SYMLINK+="coldcard"
    '';
    blueman.enable = true;
  };

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/home/${username}/sync/music";
    };
  };
  systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce false;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.hyprland.enable = true;

  security.polkit.enable = true;

  systemd.user.services."stalker" = {
    after = ["network.target"];
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "/home/${username}/.cargo/bin/stalker-bin";
      LimitNOFILE = 65536;
    };
    environment = {
      RUST_LOG = "info,sqlx=error";
      DATA_DIR = "/home/${username}/stalker-data";
    };
  };

  networking.wireless = {
    enable = false; # Enables wireless support via wpa_supplicant.
  };

  networking.firewall = {
    enable = true;
  };
  networking.nftables.enable = true;

  services.xserver = {
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:win_space_toggle";
    videoDrivers = ["nvidia"];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["docker"];
    shell = pkgs.nushell;
  };

  users.users.docker = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };

  environment.systemPackages = with pkgs; [
    firefox
    mullvad-browser
    mullvad-vpn
    tor-browser-bundle-bin

    logseq

    electrum

    kanata
    qmk

    restic
    rclone
  ];

  sops = {
    age.keyFile = "/home/${username}/sync/keys/nixos-config.age";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.bluetooth.enable = true;
}
