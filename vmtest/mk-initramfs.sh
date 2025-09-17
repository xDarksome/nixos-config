set -e

ROOTFS_DEST=rootfs

# Stop mkinitfs from running during apk install.
mkdir -p "$ROOTFS_DEST/etc/mkinitfs"
echo "disable_trigger=yes" > "$ROOTFS_DEST/etc/mkinitfs/mkinitfs.conf"

export ALPINE_BRANCH=edge
export SCRIPT_CHROOT=yes
export FS_SKEL_DIR=root
export FS_SKEL_CHOWN=root:root
PACKAGES="$(cat packages)"
export PACKAGES
alpine-make-rootfs "$ROOTFS_DEST" setup.sh

cd "$ROOTFS_DEST"
# mv boot "$IMAGE_DEST"
find . | cpio -o -H newc | gzip > ../initramfs
