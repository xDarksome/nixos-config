{
  lib,
  pkgs,
  username,
  ...
}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home-manager.users.${username} = {pkgs, ...}: {
    wayland.windowManager.sway = let
      mod = "Mod4";
    in {
      enable = true;
      config = {
        modifier = mod;

        left = "h";
        down = "t";
        up = "d";
        right = "s";

        # output."*" = {
        #   bg = "~/sync/wallpapers/cyborg-girl-white.jpg fit";
        # };

        # Logitech G502 ID doesn't work for some reason, so it's hacked by setting wildcard and then
        # ovewriting for everything else.
        input = {
          "*" = {
            accel_profile = "flat";
            pointer_accel = "0.0";
          };
          "1133:16495:Logitech_MX_Ergo" = {
            accel_profile = "adaptive";
          };
          "type:keyboard" = {
            "repeat_delay" = "300";
            "repeat_rate" = "30";
            "xkb_layout" = "us,ru";
            "xkb_options" = "grp:win_space_toggle";
          };
        };

        keybindings = {
          "${mod}+Return" = "exec wezterm";
          "${mod}+Escape" = "kill";
          "${mod}+Tab" = "exec dmenu_path | dmenu | xargs swaymsg exec --";

          "${mod}+l" = "exec swaylock";

          "${mod}+c" = "workspace number 1";
          "${mod}+i" = "workspace number 2";
          "${mod}+e" = "workspace number 3";
          "${mod}+a" = "workspace number 4";
          "${mod}+b" = "workspace number 5";
          "${mod}+y" = "workspace number 6";
          "${mod}+o" = "workspace number 7";
          "${mod}+u" = "workspace number 8";

          "${mod}+Shift+c" = "move container to workspace number 1";
          "${mod}+Shift+i" = "move container to workspace number 2";
          "${mod}+Shift+e" = "move container to workspace number 3";
          "${mod}+Shift+a" = "move container to workspace number 4";
          "${mod}+Shift+b" = "move container to workspace number 5";
          "${mod}+Shift+y" = "move container to workspace number 6";
          "${mod}+Shift+o" = "move container to workspace number 7";
          "${mod}+Shift+u" = "move container to workspace number 8";
        };

        bars = [
          {
            mode = "hide";
            hiddenState = "hide";
            statusCommand = "while date +'%Y-%m-%d %I:%M:%S %p'; do sleep 1; done";
          }
        ];
      };

      extraConfigEarly = ''
        exec swww-daemon
      '';

      extraConfig = ''
        exec swww-daemon
        exec swww img sync/wallpapers/cyborg-girl-white.jpg

        smart_borders on
        default_border pixel 1
        default_floating_border pixel 1
        font pango:monospace 10
        titlebar_padding 1
        titlebar_border_thickness 1
      '';
    };
  };
}
