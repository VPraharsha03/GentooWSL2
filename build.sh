#!/bin/bash
set -e -x
export PATH=/usr/.bin:$PATH

# Env variables for the Gentoo image
OS_VER="stable"
ROOTFS_VER="20230319T170303Z"
ROOTFS_URL="https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64-nomultilib-openrc/stage3-amd64-nomultilib-openrc-${ROOTFS_VER}.tar.xz"

# Environment variables for Yuk7's wsldl
LNCR_BLD="22020900"
LNCR_ZIP="icons.zip"
LNCR_NAME="Gentoo"
LNCR_FN=${LNCR_NAME}.exe
LNCR_ZIPFN=${LNCR_NAME}.exe
LNCR_URL="https://github.com/yuk7/wsldl/releases/download/${LNCR_BLD}/${LNCR_ZIP}"

# Create a work dir
mkdir rootfs

# Download the Gentoo Rootfs and Yuk7's WSLDL
curl -L ${ROOTFS_URL} --output base.tar.xz
curl -L ${LNCR_URL} --output ${LNCR_ZIP}

# Extract the Gentoo WSL launcher
unzip ${LNCR_ZIP} ${LNCR_FN}

# Clean up
rm ${LNCR_ZIP}

# Extract rootfs
sudo tar -xpf base.tar.xz -C rootfs
sudo chmod +x rootfs

# Delete auto-generated files
# rm rootfs/etc/resolv.conf || true
# rm rootfs/etc/wsl.conf || true

# Enable changing /etc/resolv.conf
# Enable extended attributes on Windows drives
cat <<EOF > rootfs/etc/wsl.conf
[network]
generateResolvConf = false

[automount]
enabled = true
options = "metadata"
mountFsTab = false
EOF

# Use google nameservers for DNS resolution
cat <<EOF > rootfs/etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Make changes to /etc/portage/make.conf
cat <<EOF > rootfs/etc/portage/make.conf
# No GUI (-X -gtk), only english error messages (-nls)
USE="-X -gtk -nls"

# Enable python 3.7 and set 3.6 as default
PYTHON_TARGETS="python3_6 python3_7"
PYTHON_SINGLE_TARGET="python3_6"

# Define targets for QEMU
QEMU_SOFTMMU_TARGETS="aarch64 arm i386 riscv32 riscv64 x86_64"
QEMU_USER_TARGETS="aarch64 arm i386 riscv32 riscv64 x86_64"

# No hardware videocard support
VIDEO_CARDS="dummy"

# Disable non-functional sandboxing features
FEATURES="-ipc-sandbox -pid-sandbox -mount-sandbox -network-sandbox"

# Always ask when managing packages, always consider deep dependencies (slow)
EMERGE_DEFAULT_OPTS="--ask --complete-graph"

# Enable optimizations for the used CPU
#COMMON_FLAGS="-march=haswell -O2 -pipe"
#CHOST="x86_64-pc-linux-gnu"
#CFLAGS="${COMMON_FLAGS}"
#CXXFLAGS="${COMMON_FLAGS}"
#FCFLAGS="${COMMON_FLAGS}"
#FFLAGS="${COMMON_FLAGS}"
#MAKEOPTS="-j5"

# NOTE: This stage was built with the bindist Use flag enabled
PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
EOF

# Clean up (delete base.tar.gz)
rm base.tar.xz

# Create a tar.gz of the rootfs
sudo tar -zcpf rootfs.tar.gz -C ./rootfs .
sudo chown "$(id -un)" rootfs.tar.gz

# Clean up
sudo rm -rf rootfs

# Create the distribution zip of Gentoo WSL 
mkdir out
mkdir dist
mv -f ${LNCR_FN} ./out/${LNCR_ZIPFN}
mv -f rootfs.tar.gz ./out/
pushd out
zip ../dist/Gentoo.zip ./*
popd

# Clean up
rm -rf out
