{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [wezterm];

  home-manager.users.${username}.home.file = {
    ".config/wezterm/wezterm.lua".source = ./config.lua;
  };
}
