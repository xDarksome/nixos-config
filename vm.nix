({
  inputs,
  lib,
  pkgs,
  username,
  # packages ? "",
  # , tapInterface ? null,
  ...
}: let
  index = 1;
  mac = "00:00:00:00:00:01";
in {
  microvm = {
    hypervisor = "cloud-hypervisor";
    graphics.enable = true;
    mem = 4096;
    preStart = ''
      XDG_RUNTIME_DIR=/run/user/1000
      WAYLAND_DISPLAY=wayland-1
    '';

    interfaces = [ {
      id = "vm1";
      type = "tap";
      inherit mac;
    } ];

    # interfaces = [
    #   {
    #     type = "macvtap";
    #     id = "vm";
    #     mac = "02:42:c0:a8:11:02";
    #     macvtap = {
    #       link = "wlo1";
    #       mode = "bridge";
    #     };
    #   }
    # ];

    # interfaces = [{
    #   type = "tap";
    #   id = "vm";
    #   mac = "02:00:00:00:00:01";
    # }];
    # shares = [
    #   {
    #     tag = "wg";
    #     source = "/run/secrets/chromium";
    #     mountPoint = "/run/secrets/chromium";
    #     proto = "virtiofs";
    #     socket = "/var/lib/microvms/chromium/graphical-microvm-virtiofs-wg.sock";
    #   }
    # ];
  };


    services.openssh = {
      enable = true;
      # startWhenNeeded = false;
      # listenAddresses = [ ];
      settings = {
        # PermitRootLogin = "yes";
        PasswordAuthentication = true;
        PermitEmptyPasswords = true;
        # UsePAM = true;
      };
    };

    # services.openssh = {
    #   enable = true;
    #   startWhenNeeded = false;
    #   listenAddresses = [ ];
    #   settings = {
    #     PermitRootLogin = "yes";
    #     PasswordAuthentication = true;
    #     PermitEmptyPasswords = true;
    #     UsePAM = true;
    #   };
    # };

  # networking.useNetworkd = true;
  # networking.useDHCP = false;

  networking.useNetworkd = true;

  systemd.network.networks."10-eth" = {
    matchConfig.MACAddress = mac;
    # Static IP configuration
    address = [
      "10.0.0.${toString index}/32"
      "fec0::${lib.toHexString index}/128"
    ];
    routes = [ {
      # A route to the host
      Destination = "10.0.0.0/32";
      GatewayOnLink = true;
    } {
      # Default route
      Destination = "0.0.0.0/0";
      Gateway = "10.0.0.0";
      GatewayOnLink = true;
    } {
      # Default route
      Destination = "::/0";
      Gateway = "fec0::";
      GatewayOnLink = true;
    } ];
    networkConfig = {
      # DNS servers no longer come from DHCP nor Router
      # Advertisements. Perhaps you want to change the defaults:
      DNS = [
        # Quad9.net
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
    };
  };

  # systemd.network.networks."10-eth" = {
  #   matchConfig.MACAddress = mac;
  #   # Static IP configuration
  #   address = [
  #     "172.16.0.${toString index}/32"
  #     "fec0::${lib.toHexString index}/128"
  #   ];
  #   routes = [ {
  #     # A route to the host
  #     Destination = "172.16.0.100/32";
  #     GatewayOnLink = true;
  #   } {
  #     # Default route
  #     Destination = "0.0.0.0/0";
  #     Gateway = "172.16.0.100";
  #     GatewayOnLink = true;
  #   } {
  #     # Default route
  #     Destination = "::/0";
  #     Gateway = "fec0::";
  #     GatewayOnLink = true;
  #   } ];
  #   networkConfig = {
  #     # DNS servers no longer come from DHCP nor Router
  #     # Advertisements. Perhaps you want to change the defaults:
  #     DNS = [
  #       # Quad9.net
  #       "9.9.9.9"
  #       "149.112.112.112"
  #       "2620:fe::fe"
  #       "2620:fe::9"
  #     ];
  #   };
  # };

  # networking.interfaces.ens3.ipv4.addresses = [{
  #   address = "192.168.100.2";
  #   prefixLength = 24;
  # }];

  # networking.useNetworkd = false;
  # networking.defaultGateway = "192.168.100.1";
  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # systemd.network.enable = true;

  # systemd.network.networks."20-lan" = {
  #   matchConfig.Type = "ether";
  #   networkConfig = {
  #     Address = ["192.168.1.3/24" "2001:db8::b/64"];
  #     Gateway = "192.168.1.1";
  #     DNS = ["192.168.1.1"];
  #     IPv6AcceptRA = true;
  #     DHCP = "no";
  #   };
  # };

  # networking.wg-quick.interfaces.wg0 = {
  #   configFile = "/run/secrets/chromium/wg-quick";
  #   # autostart = false;
  # };

  networking.hostName = "graphical-microvm";
  system.stateVersion = lib.trivial.release;
  nixpkgs.overlays = [inputs.microvm.overlay];

  # users.users.${username} = {
  #   isNormalUser = true;
  #   extraGroups = ["networkmanager" "wheel"];
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBJcLJ7ZGkut93mp+aAdn3NQVmV3oWIE4xQLcZo3mkl"
  #   ];
  # };

  services.getty.autologinUser = "user";
  users.users.user = {
    hashedPassword = "";
    group = "user";
    isNormalUser = true;
    extraGroups = ["wheel" "video"];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBJcLJ7ZGkut93mp+aAdn3NQVmV3oWIE4xQLcZo3mkl"
    ];
  };
  users.groups.user = {};
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-1";
    DISPLAY = ":0";
    QT_QPA_PLATFORM = "wayland"; # Qt Applications
    GDK_BACKEND = "wayland"; # GTK Applications
    XDG_SESSION_TYPE = "wayland"; # Electron Applications
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  systemd.user.services.wayland-proxy = {
    enable = true;
    description = "Wayland Proxy";
    serviceConfig = with pkgs; {
      # Environment = "WAYLAND_DISPLAY=wayland-1";
      ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = ["default.target"];
  };

  environment.systemPackages = with pkgs;
    [
      xdg-utils # Required
      chromium
      firefox
      tcpdump
    ];

  hardware.graphics.enable = true;
})
