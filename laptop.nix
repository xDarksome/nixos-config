{
  lib,
  config,
  inputs,
  pkgs,
  username,
  appimageTools,
  ...
}:
let
# vmKernel = pkgs.linuxPackages_custom {
#   version = "6.12.41";
#   src = pkgs.fetchurl {
#     url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.41.tar.xz";
#     sha256 = "sha256-axmjrplCPeJBaWTWclHXRZECd68li0xMY+iP2H2/Dic=";
#   };
#   configfile = ./kernel_config;
# }; 
in {
  imports = [
    ./machine.nix

    ./mullvad-vpn

    ./sops

    # ./kanata/mod.nix

    ./nix-bitcoin/mod.nix
    ./monero/mod.nix

    ./glance

    ./qbittorrent

    ./cosmic/mod.nix

    ./chromium

    ./mpv

    ./syncthing/mod.nix
  ];

  # networking.useNetworkd = true;
  # only being used for VMs
  # systemd.network.wait-online.enable = false;

  # networking.useDHCP = false;
  # networking.networkmanager.enable = false;

  # networking.wireless.enable = true;
  # networking.wireless.userControlled.enable = true;
  # networking.wireless.allowAuxiliaryImperativeNetworks = true;

  boot.kernel.sysctl = {
    # Enable IP forwarding
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    enable = true;
  };
  networking.nftables.enable = true;

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
      KERNELS=="input*", ATTRS{name}=="Asus Keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
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

  services.xserver = {
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:win_space_toggle";
    videoDrivers = ["nvidia"];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["docker" "dialout" "tty"];
    shell = pkgs.nushell;
  };

  users.users.docker = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };

  environment.variables = {
    # "VM_KERNEL" = "${vmKernel.kernel}";
    # "VM_KERNEL_BIN" = "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";
    # "VM_KERNEL_INITRD" = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";   
  };

  environment.systemPackages = with pkgs; [
    firefox
    mullvad-browser
    mullvad-vpn
    tor-browser-bundle-bin

    logseq

    electrum

    # kanata
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



  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [username];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  networking.firewall.trustedInterfaces = [ "virbr0" ];

}
