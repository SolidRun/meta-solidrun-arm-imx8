#!/bin/sh

. sources/meta-imx/tools/imx-setup-release.sh


echo "" >> $BUILD_DIR/conf/bblayers.conf
# TODO meta-hailo has no public scarthgap branch so commenting these out for now
echo "#BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-accelerator\"" >> $BUILD_DIR/conf/bblayers.conf
echo "#BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-libhailort\"" >> $BUILD_DIR/conf/bblayers.conf
echo "#BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-tappas\"" >> $BUILD_DIR/conf/bblayers.conf

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-solidrun-arm-imx8\"" >> $BUILD_DIR/conf/bblayers.conf

# TODO confirm that firmware-nxp-wifi recipe has deprecated linux-firmware_%.bbappend in meta-imx
# see https://github.com/nxp-imx/meta-imx/pull/25
echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBMASK ?= \"\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBMASK += \"\${BSPDIR}/meta-imx/meta-imx-bsp/recipes-kernel/linux-firmware/linux-firmware.*.bbappend\"" >> $BUILD_DIR/conf/bblayers.conf
