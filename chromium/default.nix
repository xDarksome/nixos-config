{
  inputs,
  pkgs,
  username,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [chromium];

  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = {
  #     chromium = {
  #       executable = "${pkgs.chromium}/bin/chromium";
  #       profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
  #       extraArgs = [
  #         # Required for U2F USB stick
  #         # "--ignore=private-dev"
  #         # Enforce dark mode
  #         # "--env=GTK_THEME=Adwaita:dark"
  #         # Enable system notifications
  #         # "--dbus-user.talk=org.freedesktop.Notifications"
  #         "--net=wlo1"
  #       ];
  #     };
  #   };
  # };

  # sops.secrets.chromium-wg-quick = {
  #   sopsFile = ./wg-quick.conf;
  #   restartUnits = ["wg-quick-chromium.service"];
  #   format = "binary";
  # };

  # networking.wg-quick.interfaces.chromium = {
  #   configFile = config.sops.secrets.chromium-wg-quick.path;
  #   autostart = false;
  # };

  # microvm.vms = {
  #   chromium = {
  #     config = {
  #       nixpkgs.overlays = [inputs.microvm.overlay];

  #       microvm = {
  #         hypervisor = "cloud-hypervisor";
  #         graphics.enable = true;
  #         # interfaces = lib.optional (tapInterface != null) {
  #         #   type = "tap";
  #         #   id = tapInterface;
  #         #   mac = "00:00:00:00:00:02";
  #         # };
  #       };

  #       networking.hostName = "chromium";
  #     };
  #   };
  # };
}
