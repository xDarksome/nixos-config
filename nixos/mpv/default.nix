{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [mpv];

  home-manager.users.${username}.home.file = {
    ".config/mpv/mpv.conf".source = ./mpv.conf;
  };
}
