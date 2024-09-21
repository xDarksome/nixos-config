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
          "type:touch" = {
            "events" = "disabled";
          };
          "type:touchpad" = {
            "events" = "enabled";
          };
        };

        keybindings = {
          "${mod}+h" = "focus left";
          "${mod}+s" = "focus right";
          "${mod}+d" = "focus up";
          "${mod}+m" = "focus down";

          "${mod}+Alt+h" = "move left";
          "${mod}+Alt+s" = "move right";
          "${mod}+Alt+d" = "move up";
          "${mod}+Alt+m" = "move down";
          
          "${mod}+n" = "exec wezterm";
          "${mod}+b" = "kill";
          "${mod}+c" = "exec dmenu_path | dmenu | xargs swaymsg exec --";

          "${mod}+l" = "exec swaylock -i sync/wallpapers/cyborg-girl-white.jpg";

          "${mod}+y" = "workspace number 1";
          "${mod}+o" = "workspace number 2";
          "${mod}+u" = "workspace number 3";
          "${mod}+i" = "workspace number 4";
          "${mod}+e" = "workspace number 5";
          "${mod}+a" = "workspace number 6";
          "${mod}+x" = "workspace number 7";
          "${mod}+j" = "workspace number 8";
          "${mod}+k" = "workspace number 9";

          "${mod}+Alt+y" = "move container to workspace number 1";
          "${mod}+Alt+o" = "move container to workspace number 2";
          "${mod}+Alt+u" = "move container to workspace number 3";
          "${mod}+Alt+i" = "move container to workspace number 4";
          "${mod}+Alt+e" = "move container to workspace number 5";
          "${mod}+Alt+a" = "move container to workspace number 6";
          "${mod}+Alt+x" = "move container to workspace number 7";
          "${mod}+Alt+j" = "move container to workspace number 8";
          "${mod}+Alt+k" = "move container to workspace number 9";
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
