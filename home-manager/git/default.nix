{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [git];

  home.file = {
    ".config/git/config".source = ./config.toml;
  };
}
