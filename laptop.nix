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
  ];

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udev.packages = with pkgs; [bazecor android-udev-rules];
  };

  programs = {
    steam.enable = true;
    virt-manager.enable = true;
  };

  security.polkit.enable = true;

  systemd.services."user@".serviceConfig.Delegate = ["cpu" "cpuset" "io" "memory" "pids"];

  networking.wireless = {
    enable = false; # Enables wireless support via wpa_supplicant.
    iwd.enable = true;
  };

  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
    videoDrivers = ["nvidia"];
  };

  services.gnome = {
    gnome-keyring.enable = true;
    tracker-miners.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["docker" "libvirtd"];
  };

  users.users.docker = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };

  environment.systemPackages = with pkgs; [
    rust-analyzer
    rustup

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
    termusic

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
    monero-gui

    flameshot

    kanata

    (bazecor.overrideAttrs {
     src = pkgs.appimageTools.extract {
        pname = "bazecor";
        version = "1.4.0-rc.3";

        src = fetchurl {
          url = "https://github.com/Dygmalab/Bazecor/releases/download/v1.4.0-rc.3/Bazecor-1.4.0-rc.3-x64.AppImage";
          hash = "sha256-ojAVBNSknOvh8L4dqkoxHw3aYoWr0Wb81kVptNVCC3o=";
        };

        # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
        postExtract = ''
          substituteInPlace \
            $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
            --replace \
              'checkUdev=()=>{try{if(c.default.existsSync(f))return c.default.readFileSync(f,"utf-8").trim()===l.trim()}catch(e){console.error(e)}return!1}' \
              'checkUdev=()=>{return 1}'
        '';
      };           
      
    })

    (looking-glass-client.overrideAttrs {
      src = fetchFromGitHub {
        owner = "gnif";
        repo = "LookingGlass";
        rev = "B6-rc1";
        sha256 = "sha256-FZjwLY2XtPGhwc/GyAAH2jvFOp61lSqXqXjz0UBr7uw=";
        fetchSubmodules = true;
      };
    })

    # virt manager is broken without this
    gnome3.adwaita-icon-theme # default gnome cursors
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

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
}
