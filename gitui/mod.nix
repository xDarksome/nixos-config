{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [gitui];

  home-manager.users.${username}.home.file = {
    ".config/gitui/key_bindings.ron".source = ./key_bindings.ron;
  };
}
