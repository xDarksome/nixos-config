{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [helix];

  home-manager.users.${username}.home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/themes".source = ./themes;
  };
}
