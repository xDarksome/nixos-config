{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./nushell
    ./git
    ./gitui
    ./helix
    ./xplr
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    zoxide

    unixtools.whereis
    wget
    zip
    unzip

    gnupg
    gpg-tui
    pinentry-curses

    dua

    btop
  ];

  home.stateVersion = "24.05";
}
