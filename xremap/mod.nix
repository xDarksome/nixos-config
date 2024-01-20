{
  pkgs,
  username,
  inputs,
  ...
}: {
  imports = [inputs.xremap-flake.nixosModules.default];

  services.xremap = {
    userName = username;
    serviceMode = "user";
    withWlroots = true;
    watch = true;
    mouse = true;
    extraArgs = ["--device='Logitech G502'" "--device='Razer Blade Keyboard'"];
    config = {
      modmap = [
        {
          device = {only = ["Logitech G502"];};
          remap = {"LeftShift" = "LeftCtrl";};
        }

        {
          application = {not = ["dota2"];};
          remap = {
            "CapsLock" = "Tab";
            "Tab" = "Esc";
            "LeftAlt" = "LeftMeta";
            "LeftMeta" = "LeftAlt";
            "RightAlt" = "RightCtrl";
          };
        }
      ];
    };
  };
}
