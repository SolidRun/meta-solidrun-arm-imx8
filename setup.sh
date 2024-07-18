#!/bin/sh

. sources/meta-imx/tools/imx-setup-release.sh

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-accelerator\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-libhailort\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-hailo/meta-hailo-tappas\"" >> $BUILD_DIR/conf/bblayers.conf

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-solidrun-arm-imx8\"" >> $BUILD_DIR/conf/bblayers.conf

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-arm/meta-arm\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-arm/meta-arm-toolchain\"" >> $BUILD_DIR/conf/bblayers.conf
