{
  pkgs,
  username,
  home-manager,
  ...
}: {
  environment.systemPackages = with pkgs; [git];

  home-manager.users.${username}.home.file = {
    ".config/git/config".source = ./config.toml;
  };
}
