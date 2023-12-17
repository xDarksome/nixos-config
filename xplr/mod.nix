{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [ xplr ];

  home-manager.users.${username}.home.file = {
    ".config/xplr/init.lua".source = ./init.lua;
    ".config/xplr/plugins/nuke".source = pkgs.fetchFromGitHub {
      owner = "Junker";
      repo = "nuke.xplr";
      rev = "f83a7ed58a7212771b15fbf1fdfb0a07b23c81e9";
      hash = "sha256-k/yre9SYNPYBM2W1DPpL6Ypt3w3EMO9dznHwa+fw/n0=";
    };
  };
}
