{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.kmonad.nixosModules.default];

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
}
