{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, perl
, fontconfig
, copyDesktopItems
, makeDesktopItem
, glib
, gtk3
, openssl
, wrapGAppsHook
, gobject-introspection
}:

rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "1c7815b3c7800bb3903e0adffbb528cd8f2d3894";
    sha256 = "sha256-0GXERUkDuM6PYDR++Ptr3F5LF3abdEL+lc6ES+VpTsA=";
  };

  cargoSha256 = "sha256-DeKxNsIU4QzdFdXWpPd1cYYDGIlSfG52bXU5tTLDEj0=";

  nativeBuildInputs = [ 
    cmake
    pkg-config
    perl
    copyDesktopItems
    wrapGAppsHook # FIX: No GSettings schemas are installed on the system
    gobject-introspection
  ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    glib
    gtk3
    openssl
    fontconfig
  ];

  postInstall = ''
    install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/lapce.svg
  '';

  desktopItems = [ (makeDesktopItem {
    name = "lapce";
    exec = "lapce %F";
    icon = "lapce";
    desktopName = "Lapce";
    comment = meta.description;
    genericName = "Code Editor";
    categories = [ "Development" "Utility" "TextEditor" ];
  }) ];

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
  };
}