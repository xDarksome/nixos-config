{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [nushell];

  home-manager.users.${username}.home.file = {
    ".config/nushell/config.nu".source = ./config.nu;
    ".config/nushell/env.nu".source = ./env.nu;
  };
}
