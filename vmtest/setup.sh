#!/bin/sh
set -e

export PATH=/usr/sbin:/usr/bin:/sbin:/bin

ln -sf /sbin/openrc-init /init

rc-update add devfs sysinit
rc-update add dmesg sysinit

rc-update add hwclock boot
rc-update add modules boot
rc-update add sysctl boot
rc-update add hostname boot
rc-update add bootmisc boot
rc-update add syslog boot
rc-update add klogd boot
rc-update add networking boot
rc-update add seedrng boot

rc-update add mount-ro shutdown
rc-update add killprocs shutdown

ln -sf /etc/init.d/agetty /etc/init.d/agetty.ttyS0
# ln -s /etc/init.d/agetty /etc/init.d/agetty.tty1

rc-update add agetty.ttyS0 default
# rc-update add agetty.tty1 default

rc-update add acpid default
rc-update add crond default
rc-update add local default
# rc-update add openntpd default
# rc-update add sshd default
# rc-update add tailscale default

echo "root:root" | chpasswd

