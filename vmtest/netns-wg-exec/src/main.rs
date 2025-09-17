use nix::fcntl::{OFlag, open};
use nix::libc::{self, IFF_NO_PI, IFF_TAP, IFF_VNET_HDR, IFNAMSIZ, TUNSETIFF, c_short};
use nix::sched::{CloneFlags, setns};
use nix::sys;
use nix::sys::memfd::{MFdFlags, memfd_create};
use nix::unistd::{Uid, getuid, setresuid, write};
use std::os::fd::{AsFd, AsRawFd, IntoRawFd, OwnedFd};
use std::os::unix::process::CommandExt;
use std::process::Stdio;
use std::{
    fs::{self, File},
    path::Path,
    process::{Command, exit},
};

fn main() {
    let ns_name = &env("NETWORK_NAMESPACE_NAME");
    let priv_key = &env("WIREGUARD_INTERFACE_PRIVATE_KEY");
    let addr = &env("WIREGUARD_INTERFACE_ADDRESS");
    let dns = &env("WIREGUARD_INTERFACE_DNS");
    let peer_pub_key = &env("WIREGUARD_PEER_PUBLIC_KEY");
    let peer_endpoint = &env("WIREGUARD_PEER_ENDPOINT");

    let memfd = memfd_create("wg-key", MFdFlags::empty()).expect("failed to create memfd");
    let memfd_path = &format!("/proc/self/fd/{}", memfd.as_raw_fd());
    write(&memfd, priv_key.as_bytes()).expect("failed to write to memfd");

    let ns_path = Path::new("/var/run/netns").join(ns_name);
    if std::fs::exists(&ns_path).expect("fs::exists") {
        run("ip", &["netns", "delete", ns_name]);
    }

    run("ip", &["netns", "add", ns_name]);

    run("ip", &["link", "add", "wg", "type", "wireguard"]);
    run("ip", &["link", "set", "wg", "netns", ns_name]);

    let uid = getuid();
    let uid0 = Uid::from_raw(0);
    setresuid(uid0, uid0, uid0).expect("setresuid");

    let ns_file = File::open(ns_path).expect("Failed to open netns file");

    setns(ns_file.as_fd(), CloneFlags::CLONE_NEWNET).expect("setns");

    run("ip", &["link", "set", "lo", "up"]);

    let wg_args = [
        "set",
        "wg",
        "private-key",
        memfd_path,
        "peer",
        peer_pub_key,
        "endpoint",
        peer_endpoint,
        "allowed-ips",
        "0.0.0.0/0, ::/0",
    ];
    run("wg", &wg_args);

    run("ip", &["a", "add", addr, "dev", "wg"]);
    run("ip", &["link", "set", "wg", "up"]);
    run("ip", &["route", "add", "default", "dev", "wg"]);

    let ip_tables_args = [
        "-t",
        "nat",
        "-A",
        "POSTROUTING",
        "-s",
        "192.168.100.0/24",
        "-o",
        "wg",
        "-j",
        "MASQUERADE",
    ];
    run("iptables", &ip_tables_args);

    run("ip", &["tuntap", "add", "dev", "tap0", "mode", "tap"]);
    run("ip", &["link", "set", "tap0", "up"]);
    run("ip", &["addr", "add", "192.168.100.1/24", "dev", "tap0"]);

    fs::create_dir_all(format!("/etc/netns/{ns_name}")).expect("fs::create_dir_all");
    fs::write(
        format!("/etc/netns/{ns_name}/resolv.conf"),
        format!("nameserver {dns}"),
    )
    .expect("write resolv.conf");

    let tap_fd = get_tap_fd("tap0").into_raw_fd();

    setresuid(uid, uid, uid).expect("setresuid");

    let mut args = std::env::args();
    let (_, program) = (args.next().unwrap(), args.next().expect("program"));

    let err = Command::new(&program)
        .args(args)
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .env("TAP_FD", format!("{tap_fd}"))
        .exec();

    panic!("exec failed: {err}");
}

fn run(cmd: &str, args: &[&str]) {
    let status = Command::new(cmd)
        .args(args)
        .status()
        .unwrap_or_else(|e| panic!("Failed to run {}: {}", cmd, e));

    if !status.success() {
        eprintln!("Command {} {:?} failed with {}", cmd, args, status);
        exit(status.code().unwrap_or(1));
    }
}

fn env(name: &str) -> String {
    std::env::var(name).expect(name)
}

fn get_tap_fd(name: &str) -> OwnedFd {
    #[repr(C)]
    struct IfReq {
        name: [u8; IFNAMSIZ],
        flags: c_short,
    }

    let fd = open("/dev/net/tun", OFlag::O_RDWR, sys::stat::Mode::empty()).expect("open tap fd");

    let mut ifr = IfReq {
        name: [0u8; IFNAMSIZ],
        flags: (IFF_TAP | IFF_NO_PI | IFF_VNET_HDR) as c_short,
    };

    let bytes = name.as_bytes();
    ifr.name[..bytes.len()].copy_from_slice(bytes);

    // SAFETY: `TUNSETIFF` expects `ifreq` to be 16 byte name + 2 byte flags
    let code = unsafe { libc::ioctl(fd.as_raw_fd(), TUNSETIFF, &ifr) };

    if code < 0 {
        panic!("ioctl errored: {code}")
    } else {
        fd
    }
}
