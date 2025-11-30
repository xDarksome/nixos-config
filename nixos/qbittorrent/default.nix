{
  lib,
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

  system.activationScripts.symlinks.text = lib.mkAfter ''
    rm -rf /home/${username}/.config/qBittorrent
    ln -s /home/${username}/nixos-config/nixos/qbittorrent/config /home/${username}/.config/qBittorrent
  '';
}
