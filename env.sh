# Env variables for the Gentoo image
OS_VER="stable"
ROOTFS_VER="20240901T170410Z"
ROOTFS_URL="https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64-nomultilib-openrc/stage3-amd64-nomultilib-openrc-${ROOTFS_VER}.tar.xz"

# Environment variables for Yuk7's wsldl
LNCR_BLD="23051400"
LNCR_ZIP="icons.zip"
LNCR_NAME="Gentoo"
LNCR_FN=${LNCR_NAME}.exe
LNCR_ZIPFN=${LNCR_NAME}.exe
LNCR_URL="https://github.com/yuk7/wsldl/releases/download/${LNCR_BLD}/${LNCR_ZIP}"