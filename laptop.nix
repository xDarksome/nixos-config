{
  lib,
  inputs,
  pkgs,
  username,
  appimageTools,
  ...
}: {
  imports = [
    ./machine.nix

    ./kanata/mod.nix
    ./wezterm/mod.nix
    ./sway/mod.nix

    ./nix-bitcoin/mod.nix
    ./monero/mod.nix

    ./cosmic/mod.nix
  ];

  boot.supportedFilesystems = ["ntfs"];

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udev.packages = with pkgs; [
      # bazecor
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

  programs = {
    virt-manager.enable = true;
    hyprland.enable = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  security.polkit.enable = true;

  systemd.services."user@".serviceConfig.Delegate = ["cpu" "cpuset" "io" "memory" "pids"];
  systemd.user.services."stalker" = {
    after = ["network.target"];
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "/home/${username}/.cargo/bin/stalker-bin";
    };
    environment = {
      RUST_LOG = "info,sqlx=error";
      DATA_DIR = "/home/${username}/stalker-data";
    };
  };

  networking.wireless = {
    enable = false; # Enables wireless support via wpa_supplicant.
    # iwd.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [6666];
    allowedUDPPorts = [3000 3010];
  };
  networking.nftables.enable = true;

  services.xserver = {
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:win_space_toggle";
    videoDrivers = ["nvidia"];
  };

  services.gnome = {
    gnome-keyring.enable = true;
    tracker-miners.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["docker" "libvirtd"];
    shell = pkgs.nushell;
  };

  users.users.docker = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };

  environment.systemPackages = with pkgs; [
    # rust-analyzer
    # rustup

    # alacritty

    brightnessctl
    zoxide

    keepassxc
    firefox
    mullvad-browser
    mullvad-vpn
    chromium
    tor-browser-bundle-bin

    session-desktop

    pulsemixer
    # termusic

    mako
    sway
    swaybg
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swww

    logseq

    mpv
    qbittorrent

    electrum

    flameshot

    kanata

    # (bazecor.overrideAttrs {
    #  src = pkgs.appimageTools.extract {
    #     pname = "bazecor";
    #     version = "1.4.0-rc.3";

    #     src = fetchurl {
    #       url = "https://github.com/Dygmalab/Bazecor/releases/download/v1.4.0-rc.3/Bazecor-1.4.0-rc.3-x64.AppImage";
    #       hash = "sha256-ojAVBNSknOvh8L4dqkoxHw3aYoWr0Wb81kVptNVCC3o=";
    #     };

    #     # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    #     postExtract = ''
    #       substituteInPlace \
    #         $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
    #         --replace \
    #           'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===l.trim()}catch(e){console.error(e)}return!1}' \
    #           'checkUdev=()=>{return 1}'
    #     '';
    #   };

    # })

    # (looking-glass-client.overrideAttrs {
    #   src = fetchFromGitHub {
    #     owner = "gnif";
    #     repo = "LookingGlass";
    #     rev = "B6-rc1";
    #     sha256 = "sha256-FZjwLY2XtPGhwc/GyAAH2jvFOp61lSqXqXjz0UBr7uw=";
    #     fetchSubmodules = true;
    #   };
    # })

    # virt manager is broken without this
    # gnome3.adwaita-icon-theme # default gnome cursors
    glib
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;

  virtualisation.docker = {
    enable = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu.verbatimConfig = ''
      cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
          "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",

          "/dev/kvmfr0"
      ]
    '';
  };

  fonts.packages = with pkgs; [
    fira-code
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
}
