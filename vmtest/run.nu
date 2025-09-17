let wg_conf = cat "/home/darksome/sync/secrets/wg-quick/work.conf" | from ini
let wg_interface = $wg_conf.Interface
let wg_peer = $wg_conf.Peer

$env.NETWORK_NAMESPACE_NAME = "vm1ns";

$env.WIREGUARD_INTERFACE_PRIVATE_KEY = $wg_interface.PrivateKey
$env.WIREGUARD_INTERFACE_ADDRESS = $wg_interface.Address
$env.WIREGUARD_INTERFACE_DNS = $wg_interface.DNS

$env.WIREGUARD_PEER_PUBLIC_KEY = $wg_peer.PublicKey
$env.WIREGUARD_PEER_ENDPOINT = $wg_peer.Endpoint

let crosvm_job_id = job spawn -t "crosvm" {
  crosvm device gpu --socket sock --wayland-sock $"($env.XDG_RUNTIME_DIR)/($env.WAYLAND_DISPLAY)" 
}

exec /home/darksome/.cargo/bin/netns-wg-exec nu -c `(exec cloud-hypervisor
  --kernel /nix/store/l9xwnw2jxi40ccxdw0shfcbsfikh5cgc-linux-6.12.41/bzImage
  --initramfs ./initramfs
  --cmdline $"console=ttyS0 init=/init ip=192.168.100.2::192.168.100.1:255.255.255.0::eth0:none dns=($env.WIREGUARD_INTERFACE_DNS)"
  --cpus boot=2 --memory size=512M
  --net $"fd=($env.TAP_FD)"
  --serial tty --console off)`

job kill $crosvm_job_id
