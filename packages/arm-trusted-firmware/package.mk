#!/bin/bash

PKG_NAME="arm-trusted-firmware"
PKG_VERSION="2.3"
PKG_SHA256="304d372327d6ecabf89da67e2e1a7b2660f13b5851886fef1b58ae5a6d74e606"
PKG_SOURCE_DIR="$PKG_NAME-${PKG_VERSION}"
PKG_SITE="https://github.com/ARM-software/$PKG_NAME"
PKG_URL="$PKG_SITE/archive/v$PKG_VERSION.tar.gz"
PKG_ARCH="X86"
PKG_LICENSE="GPL"
PKG_SHORTDESC="ARM-software/arm-trusted-firmware"
PKG_SOURCE_NAME="$PKG_SOURCE_DIR.tar.gz"
PKG_NEED_BUILD="NO"

make_host() {
    echo "*** $0 make_host"
}

make_target() {
    ln -sf "$(basename "$PWD")" "../$PKG_NAME"
    echo "*** $0 make_target // VENDOR: $VENDOR"
    export PATH="$BUILD/toolchains/gcc-linaro-arm-none-eabi/bin:$UBOOT_COMPILER_PATH:$PATH"
    make -j$NR_JOBS CROSS_COMPILE=${UBOOT_COMPILER} PLAT=rk3399 bl31
#   make -j$NR_JOBS CROSS_COMPILE=${UBOOT_COMPILER} PLAT=rk3399
}
