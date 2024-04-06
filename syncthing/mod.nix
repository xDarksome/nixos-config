{
  pkgs,
  username,
  ...
}: {
  services.syncthing = {
    enable = true;
    user = username;
    group = "users";
    dataDir = "/home/${username}";
    settings = {
      folders = {
        "/home/${username}/sync" = {
          id = "default";
          type = "sendreceive";
          devices = ["pixel3" "pixel8"];
        };
      };
      devices = {
        pixel3 = {
          id = "INU43JH-4IS3OYI-GX4HMJR-SD27VGF-6SSOXVI-TBYJUSI-LATWKIO-CETD7A4";
        };
        pixel8 = {
          id = "FVLS5OP-F4WWLTG-X2QRZ7O-FEOD6W3-KOGCXIW-AG7WHYS-UBLXCAY-COW6NA7";
        };
      };
    };
  };
}
