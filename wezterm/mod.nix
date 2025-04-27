{
  pkgs,
  username,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [inputs.wezterm.packages.x86_64-linux.default];
  # environment.systemPackages = with pkgs; [wezterm];

  home-manager.users.${username}.home.file = {
    ".config/wezterm/wezterm.lua".source = ./config.lua;
  };
}
