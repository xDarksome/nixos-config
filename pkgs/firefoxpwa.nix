{ lib
, pkg-config
, openssl
, rustPlatform
, fetchFromGitHub
, pkgs
}:
let
  repo = fetchFromGitHub {
      owner = "xDarksome";
      repo = "PWAsForFirefox";
      rev = "2fde3741571c47ac5a62d675b6ecb436a798bc2f";
      sha256 = "sha256-TfStawnTJ+joOnnXCXn3k64Y3VjjACwzcz9NUlJSTpw=";
  };
  myFirefox = pkgs.firefox.override {
    extraPrefs = builtins.readFile "${repo}/native/userchrome/runtime/_autoconfig.cfg";
  };
in {
  runtime = myFirefox;
  toolkit = rustPlatform.buildRustPackage rec {
    pname = "firefoxpwa"; 
    version = "2.0.3";

    src = "${repo}/native";

    cargoSha256 = "sha256-ZS9UHt+gF3qh7xwST8r+BXd3gJx+kNfj5+W9JCa/uBw=";

    preBuild = ''
      echo ${myFirefox}

      export FFPWA_EXECUTABLES=$out/bin
      export FFPWA_SYSDATA=$out
      export FFPWA_RUNTIME=${myFirefox}/lib/firefox
    '';

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl.dev
    ];

    postInstall = ''
      substituteInPlace manifests/linux.json \
        --replace "/usr/libexec/firefoxpwa-connector" "$out/bin/firefoxpwa-connector"
      
      install -D manifests/linux.json $out/lib/mozilla/native-messaging-hosts/firefoxpwa.json
      mkdir $out/userchrome
      cp -R userchrome/* $out/userchrome/
    '';
  };
}