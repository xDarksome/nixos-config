{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [sops];

  environment.sessionVariables.SOPS_AGE_KEY_FILE = "/home/${username}/sync/sops/keys.txt";
}
