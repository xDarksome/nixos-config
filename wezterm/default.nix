{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [wezterm];

  home.file = {
    ".config/wezterm/wezterm.lua".source = ./config.lua;
  };
}
