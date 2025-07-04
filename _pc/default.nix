{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../machine.nix

    ../wezterm/mod.nix
    ../cosmic/mod.nix
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.nushell;
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;

  fonts.packages = with pkgs; [
    fira-code
  ];
}
