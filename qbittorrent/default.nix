{
  pkgs,
  username,
  home-manager,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (qbittorrent.overrideAttrs (attrs: {
      postInstall =
        attrs.postInstall
        or ""
        + ''
          wrapProgram $out/bin/qbittorrent \
            --set QT_SCALE_FACTOR "1.5"
        '';
    }))
  ];

  home-manager.users.${username}.home.file = {
    ".config/qBittorrent/iceberg.qbtheme".source = ./iceberg.qbtheme;
    ".config/qBittorrent/qBittorrent.conf" = {
      force = true;
      text = ''
        [AddNewTorrentDialog]
        DownloadPathHistory=
        Enabled=true
        RememberLastSavePath=false
        SavePathHistory=/home/${username}/Downloads

        [GUI]
        StartUpWindowState=Minimized

        [LegalNotice]
        Accepted=true

        [Preferences]
        General\ExitConfirm=false
        General\UseCustomUITheme=true
        General\CustomUIThemePath=/home/${username}/.config/qBittorrent/iceberg.qbtheme

        [TorrentProperties]
        CurrentTab=4
        Visible=true
      '';
    };
  };
}
