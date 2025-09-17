{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nushell
    nushellPlugins.formats

    (writeShellApplication {
      name = "derive-password";

      runtimeInputs = [
        libargon2
        wl-clipboard-rs
      ];

      text = ''nu ${./derive-password.nu} "$@"'';
    })
  ];

  home-manager.users.${username}.home.file = {
    ".config/nushell/config.nu".source = ./config.nu;
    ".config/nushell/env.nu".source = ./env.nu;
    ".config/nushell/zoxide.nu".source = ./zoxide.nu;
  };
}
