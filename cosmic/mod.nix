{
  pkgs,
  username,
  inputs,
  ...
}: {
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = false;
    };
  };

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "true";
}
