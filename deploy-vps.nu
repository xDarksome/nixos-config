def main (user: string, ip: string) {
  nixos-rebuild --flake ".#vps" --target-host $"($user)@($ip)" --build-host $"($user)@($ip)" switch --fast --use-substitutes --use-remote-sudo
}
