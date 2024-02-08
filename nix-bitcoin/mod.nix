{
  pkgs,
  username,
  inputs,
  ...
}: let
  nix-bitcoin = inputs.nix-bitcoin;
in {
  imports = [nix-bitcoin.nixosModules.default];

  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  services.bitcoind.enable = true;
  services.electrs.enable = true;

  # When using nix-bitcoin as part of a larger NixOS configuration, set the following to enable
  # interactive access to nix-bitcoin features (like bitcoin-cli) for your system's main user
  nix-bitcoin.operator = {
    enable = true;
    name = username;
  };

  # If you use a custom nixpkgs version for evaluating your system
  # (instead of `nix-bitcoin.inputs.nixpkgs` like in this example),
  # consider setting `useVersionLockedPkgs = true` to use the exact pkgs
  # versions for nix-bitcoin services that are tested by nix-bitcoin.
  # The downsides are increased evaluation times and increased system
  # closure size.
  nix-bitcoin.useVersionLockedPkgs = true;
}
