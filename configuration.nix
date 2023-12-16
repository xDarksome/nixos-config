# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:
let

  # sway stuff
  
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway XDG_SESSION_TYPE=wayland
      systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
   
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

#  firefox-with-pwa = (pkgs.firefox.override {
#         extraPrefs = ''
#           function applyCustomScriptToNewWindow(win) {
#               const profile = Components.classes["@mozilla.org/file/directory_service;1"]
#                   .getService(Components.interfaces.nsIProperties)
#                   .get("ProfD", Components.interfaces.nsIFile);
#               if (profile.path.endsWith("-pwa")) {
#                   win.locationbar.visible = false;
#                   win.toolbar.visible= false;
#                   win.titlebar.style.display = 'none';

#                   win._gBrowser.addTab = function(uri) {
#                       win.MailIntegration._launchExternalUrl(win.makeURI('ff:' + uri));
#                   };
#                   win.nsBrowserAccess.prototype.createContentWindowInFrame = function(uri) {
#                       win.MailIntegration._launchExternalUrl(win.makeURI('ff:' + uri.spec));
#                       throw "Opened in Firefox";
#                   };
#               }
#           }
#           /* Single function userChrome.js loader to run the above init function (no external scripts)
#             derived from https://www.reddit.com/r/firefox/comments/kilmm2/ */
#           try {
#               let { classes: Cc, interfaces: Ci, manager: Cm } = Components;
#               const { Services } = Components.utils.import('resource://gre/modules/Services.jsm');
#               function ConfigJS() { Services.obs.addObserver(this, 'chrome-document-global-created', false); }
#               ConfigJS.prototype = {
#                   observe: function (aSubject) { aSubject.addEventListener('DOMContentLoaded', this, { once: true }); },
#                   handleEvent: function (aEvent) {
#                       let document = aEvent.originalTarget; let window = document.defaultView; let location = window.location;
#                       if (/^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(location.href)) {
#                           if (window._gBrowser) applyCustomScriptToNewWindow(window);
#                       }
#                   }
#               };
#               if (!Services.appinfo.inSafeMode) { new ConfigJS(); }
#           } catch (ex) { };
#           '';
#       });
in {
  imports = [ ./hardware-configuration.nix ];

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;


  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  programs.steam = {
    enable = true;
  };

  # services.transmission = {
  #   enable = true;
  # };
  services.deluge.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  security.polkit.enable = true;

  # programs.hyprland.enable = true;
  # programs.dconf.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # for rootless minikube
  # systemd.enableUnifiedCgroupHierarchy = true;
  systemd.services."user@".serviceConfig.Delegate = [ "cpu" "cpuset" "io" "memory" "pids" ];

  # systemd.user.services.cosmic-launcher = {
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "/bin/sh -c ${inputs.cosmic-launcher.packages.${pkgs.system}.default}/bin/cosmic-launcher";
  #     Restart = "always"; 
  #   };
  #   wantedBy = [ "default.target" ];
  # };
  
  networking.hostName = "nixos";
  networking.wireless.iwd.enable = true;

  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tbilisi";

  i18n.defaultLocale = "en_US.utf8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "unm_US/UTF-8"
  ]; 

  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
    videoDrivers = ["nvidia"];
  };

  services.kmonad = {
  	enable = true;
  	keyboards = {
  	  "razer-blade" = {
  	    device = "/dev/input/by-id/usb-Razer_Razer_Blade-if01-event-kbd";
  		defcfg = {
  		  enable = true;
  		  fallthrough = true;      	
  		};
        config = ''

          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    up   rsft
            lctl lmet lalt           spc            ralt rctl left down rght
          )

          (defalias
            lmd (around-next (layer-toggle left-mods))
            rmd (around-next (layer-toggle right-mods))

            ss (tap-next spc lsft)
            bc (tap-next bspc rctl)
          )

          (deflayer default
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            esc  q    w    e    r    t    y    u    i    o    p    [    ]    \
            tab  a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    up   rsft
            lctl lalt lmet           spc            rctl  ralt left down rght
          )

          (deflayer left-mods
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            esc  lalt lmet lctl lsft g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    up   rsft
            lctl lmet _              spc            _    rctl left down rght
          )

          (deflayer right-mods
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            esc  a    s    d    f    g    h    rsft rctl lmet lalt '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    up   rsft
            lctl lmet _              spc            _    rctl left down rght
          )
        '';
  		};
  	};
  };

  services.gnome.gnome-keyring.enable = true;
  services.gnome.tracker-miners.enable = true;

  # Required fo Nautilus
  # services.gvfs.enable = true;
  services.openssh.enable = true;
  # services.flatpak.enable = true;

  users.users.darksome = {
    isNormalUser = true;
    description = "darksome";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };
  users.users.docker = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };

  # environment.variables = {
  # 	# DOCKER_HOST = "unix://\$XDG_RUNTIME_DIR/docker.sock";

  #   # Auto --ozone-platform=wayland for VSCodium / Discord
  #   # NIXOS_OZONE_WL = "1";

  #   # Fixes IDEA grey screen.
  #   _JAVA_AWT_WM_NONREPARENTING = "1";
  # };

  environment.systemPackages = with pkgs; [
    wayfire
  
    # vimix-icon-theme
     
     # gcc
     # pkg-config
     # openssl.dev
     # cmake
     # gnumake

     unixtools.whereis
     # socat
     # wev
     # file

     rust-analyzer
     rustup
     nushell
     wget

     git
     gnupg
    
     # pamixer
     # pavucontrol
     brightnessctl
     zip
     unzip
     # connman-gtk

     # material-icons
     # papirus-icon-theme
     # font-manager

     # wayland
     # inputs.psi-shell.defaultPackage.${pkgs.system}
     # inputs.cosmic-comp.packages.${pkgs.system}.default
     # inputs.cosmic-launcher.packages.${pkgs.system}.default
     #inputs.cosmic-applets.packages.default.${pkgs.system}

     alacritty
     wezterm

     # gnome.eog
     # gnome.evince
     # transmission-gtk
     # qbittorrent
     keepassxc
     # firefox-with-pwa
     # (writeShellScriptBin "firefox-pwa-redirect" ''
     #   link=$1
     #   ${firefox}/bin/firefox -p default ''${link#ff:}
     # '')
     firefox
     librewolf
     mullvad-browser
     mullvad-vpn
     chromium
     tor-browser-bundle-bin
     # gimp
     # inkscape
     # baobab
     # mpv

     pulsemixer
     termusic

	   mako   
     sway
     swaybg
     swaylock
     swayidle
     dbus-sway-environment
     grim # screenshot functionality
     slurp # screenshot functionality
     wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
     swww

     xplr
     helix     
     gitui

     gnupg
     pinentry-curses
     rage
     pass
    
     bottom    

     logseq

     mpv
     qbittorrent
     session-desktop

     popcorntime
     nuclear

     # fixes some file picker pop-ups
     # gsettings-desktop-schemas

     # (vscode-with-extensions.override {
     #  vscode = vscodium;
     #  vscodeExtensions = with vscode-extensions; [
     #    matklad.rust-analyzer
     #    bbenoist.nix
     #  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
     #    {
     #      name = "vsc-material-theme";
     #      publisher = "Equinusocio";
     #      version = "33.5.0";
     #      sha256 = "Lls979mJuKE0+oIPAuDyl60dRzJM3WsqlShKeHpFKd8=";
     #    }
     #    {
     #      name = "vsc-material-theme-icons";
     #      publisher = "Equinusocio";
     #      version = "2.3.1";
     #      sha256 = "YKwMwcpL1Vsi789ggTIOvWDniBW6V9KGwYpYBsckVbY=";
     #    }
     #    {
     #      name = "nix-env-selector";
     #      publisher = "arrterian";
     #      version = "1.0.9";
     #      sha256 = "TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
     #    }
     #  ];
     # })

     # Only to get gtk-launch
     # gtk3

     #custom
     # pop-launcher
     # onagre
     #my-lapce
  ];

  # eww doesn't render SVGs without this
  # services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  services.syncthing = {
    enable = true;
    user = "darksome";
    group = "users";
    dataDir = "/home/darksome";
    folders = {
       "/home/darksome/sync" = {
         id = "default";
         type = "sendreceive";
         devices = ["pixel3"];
       };
    };
    devices = {
      pixel3 = {
        id = "INU43JH-4IS3OYI-GX4HMJR-SD27VGF-6SSOXVI-TBYJUSI-LATWKIO-CETD7A4";
      };
    };
  };
  
  services.dbus.enable = true;

  # services.connman.enable = true;
  # services.connman.wifi.backend = "iwd";

  #sservices.blueman.enable = true;
  
  virtualisation.docker = {
  	enable = true;
  	# rootless.enable = true;
  };
  virtualisation.podman.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.lxd.enable = true;

  fonts.fonts = with pkgs; [
    fira-code
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;
  
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.openrazer = {
  	enable = true;
  	users = ["darksome"];
  };

  system.stateVersion = "22.05";

  # sway stuff
    
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

    prime = {
      offload = {
  			enable = true;
  			enableOffloadCmd = true;
  		};

  		# Make sure to use the correct Bus ID values for your system!
  		intelBusId = "PCI:0:0:2";
  		nvidiaBusId = "PCI:0:1:0";
  	};    
  };

  home-manager.users.darksome = { pkgs, ... }: {
    wayland.windowManager.sway = 
      let mod = "Mod4"; in
    {
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

    home.file = {
      ".config/xplr/init.lua".source = ./xplr.lua;
      ".config/xplr/plugins/nuke".source = pkgs.fetchFromGitHub {
        owner = "Junker";
        repo = "nuke.xplr";
        rev = "f83a7ed58a7212771b15fbf1fdfb0a07b23c81e9";
        hash = "sha256-k/yre9SYNPYBM2W1DPpL6Ypt3w3EMO9dznHwa+fw/n0=";
      };

      ".config/wezterm/wezterm.lua".source = ./wezterm.lua; 
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };
}

