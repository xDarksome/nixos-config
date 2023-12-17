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

        left = "j";
        down = "k";
        up = "i";
        right = "l";

        # output."*" = {
        #   bg = "~/sync/wallpapers/cyborg-girl-white.jpg fit";
        # };

        input = {
          "1133:16511:Logitech_G502" = {
            accel_profile = "flat";
          };
          "type:keyboard" = {
            "repeat_delay" = "200";
            "repeat_rate" = "30";
            "xkb_layout" = "us,ru";
            "xkb_options" = "grp:win_space_toggle";
          };
        };

        keybindings = lib.mkOptionDefault {
          "${mod}+Return" = "exec wezterm";
          "${mod}+Escape" = "kill";
          "${mod}+Tab" = "exec dmenu_path | dmenu | xargs swaymsg exec --";

          "${mod}+u" = "exec swaylock";

          "${mod}+a" = "workspace number 1";
          "${mod}+s" = "workspace number 2";
          "${mod}+d" = "workspace number 3";
          "${mod}+f" = "workspace number 4";
          "${mod}+w" = "workspace number 5";
          "${mod}+e" = "workspace number 6";
          "${mod}+r" = "workspace number 7";

          "${mod}+Shift+a" = "move container to workspace number 1";
          "${mod}+Shift+s" = "move container to workspace number 2";
          "${mod}+Shift+d" = "move container to workspace number 3";
          "${mod}+Shift+f" = "move container to workspace number 4";
          "${mod}+Shift+w" = "move container to workspace number 5";
          "${mod}+Shift+e" = "move container to workspace number 6";
          "${mod}+Shift+r" = "move container to workspace number 7";
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
