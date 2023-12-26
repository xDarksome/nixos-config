{
  lib,
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./machine.nix

    ./kmonad/mod.nix
    ./wezterm/mod.nix
    ./sway/mod.nix
  ];

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  programs = {
    steam.enable = true;
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
    extraGroups = ["docker"];
  };

  users.users.docker = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };

  environment.systemPackages = with pkgs; [
    rust-analyzer
    rustup

    brightnessctl

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

  fonts.packages = with pkgs; [
    fira-code
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
}
