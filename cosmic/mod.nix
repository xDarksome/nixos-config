{
  pkgs,
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };

  environment.cosmic.excludePackages = with pkgs; [cosmic-wallpapers cosmic-player];
}
