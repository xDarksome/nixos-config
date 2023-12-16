{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in {
      pop-launcher = callPackage ./pop-launcher.nix { };
      onagre = callPackage ./onagre.nix { };

      #libadwaita1_2 = callPackage ./libadwaita1_2.nix { };
      #gnome-secrets = callPackage ./gnome-secrets.nix { };
      #gnome-builder43 = callPackage ./gnome-builder43.nix { };
      my-lapce = callPackage ./lapce.nix { };
      #firefoxpwa = callPackage ./firefoxpwa.nix { };
    };
in
lib.fix (lib.extends overrides packages)