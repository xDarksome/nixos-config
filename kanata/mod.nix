{
  pkgs,
  username,
  inputs,
  ...
}: {
  services.kanata = {
    enable = true;
    keyboards.asus = {
      devices = ["/dev/input/by-id/usb-ASUSTeK_Computer_Inc._N-KEY_Device-if02-event-kbd"];
      config = builtins.readFile ./asus.kbd;
    };
  };
}
