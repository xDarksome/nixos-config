{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [helix];

  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/themes".source = ./themes;
  };
}
