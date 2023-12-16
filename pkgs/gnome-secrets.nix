{ lib, stdenv
, meson
, ninja
, pkg-config
, gettext
, fetchFromGitLab
, python3Packages
, wrapGAppsHook4
, gtk4
, glib
, gdk-pixbuf
, gobject-introspection
, desktop-file-utils
, appstream-glib
, libadwaita1_2
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "6.5";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = "d2e81f05dbc8b6e396d57caf3d5fff0d09f1e82f";
    sha256 = "sha256-MTHSvt/FXfkqnetiVG60Jgs6BlG85PmuM5+SSfLI0c4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = with python3Packages; [
    gtk4
    glib
    gdk-pixbuf
    libadwaita1_2
    python3Packages.libpwquality.dev # Use python-enabled libpwquality
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    construct
    pykeepass
    pyotp
    libpwquality
    validators
    zxcvbn
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isStatic; # libpwquality doesn't provide bindings when static
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
