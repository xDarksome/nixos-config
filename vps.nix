{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./machine.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      ClientAliveInterval = 60;
      ClientAliveCountMax = 30;
    };
  };

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBJcLJ7ZGkut93mp+aAdn3NQVmV3oWIE4xQLcZo3mkl dev@darkso.me"
  ];
}
