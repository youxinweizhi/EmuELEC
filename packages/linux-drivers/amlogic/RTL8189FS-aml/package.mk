# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="RTL8189FS-aml"
if [ $PROJECT == "Amlogic" ]; then
PKG_VERSION="538ba58"
PKG_SHA256="3dc7602481096b8890d48915e16bf0eb1554ca1b7a3dfec6450486468aadb826"
else
PKG_VERSION="ab83abd8f068b463a60b65dacc78e97462aceb38"
PKG_SHA256="fab9511aaaa95e9764c76847ec418745bbb52f0751f3e17a51f84a6e3d4533cc"
fi
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/khadas/android_hardware_wifi_realtek_drivers_8189ftv"
PKG_URL="https://github.com/khadas/android_hardware_wifi_realtek_drivers_8189ftv/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="Realtek RTL8189FS Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

post_unpack() {
  sed -i 's/-DCONFIG_CONCURRENT_MODE//g; s/^CONFIG_POWER_SAVING.*$/CONFIG_POWER_SAVING = n/g; s/^CONFIG_RTW_DEBUG.*/CONFIG_RTW_DEBUG = n/g' $PKG_BUILD/*/Makefile
  sed -i 's/^#define CONFIG_DEBUG.*//g' $PKG_BUILD/*/include/autoconf.h
  sed -i 's/#define DEFAULT_RANDOM_MACADDR.*1/#define DEFAULT_RANDOM_MACADDR 0/g' $PKG_BUILD/*/core/rtw_ieee80211.c
}

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make -C $(kernel_path) M=$PKG_BUILD/rtl8189FS \
    ARCH=$TARGET_KERNEL_ARCH \
    KSRC=$(kernel_path) \
    CROSS_COMPILE=$TARGET_KERNEL_PREFIX \
    USER_EXTRA_CFLAGS="-fgnu89-inline"
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    find $PKG_BUILD/ -name \*.ko -not -path '*/\.*' -exec cp {} $INSTALL/$(get_full_module_dir)/$PKG_NAME \;
}
