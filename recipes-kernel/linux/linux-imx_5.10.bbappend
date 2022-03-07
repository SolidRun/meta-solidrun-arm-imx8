FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
KBUILD_DEFCONFIG_mx8 = ""
SRC_URI += " \
	file://sr_imx_v8_defconfig \
	file://0001-dt-ar803x-document-SmartEEE-properties.patch \
	file://0002-net-phy-at803x-add-support-for-configuring-SmartEEE.patch \
	file://0003-gpio-vf610-Fix-missing-include-for-pinctrl_.patch \
	file://0004-drm-bridge-it6161-Build-fix-for-a10ae796.patch \
	file://0005-ASoC-SOF-Add-missing-include-for-arm_smccc_smc.patch \
	file://0006-ASoC-fsl-Break-the-audio-cpu-dai-into-its-own-module.patch \
	file://0007-regulator-pca9450-Add-dt-property-pca-i2c-lt-en.patch \
	file://0008-net-rfkill-gpio-add-device-tree-support.patch \
	file://0009-regulator-userspace-consumer-add-DT-support.patch \
	file://0010-ARM64-dts-imx8mp-Add-SolidRun-iMX8MP-SOM-based-platf.patch \
"

DELTA_KERNEL_DEFCONFIG_mx8 += " imx_v8_defconfig sr_imx_v8_defconfig"

KERNEL_MODULE_AUTOLOAD += "imx-sdma"
FILES_${PN} += " \
	${sysconfdir}/modules-load.d/imx-sdma.conf \
	file://0008-Edit-spi-wifi-BT-imx8mp-hummingboard-dts.patch \
	file://sr_imx_v8_defconfig \
"
KBUILD_DEFCONFIG_mx8 = ""
DELTA_KERNEL_DEFCONFIG_mx8 += " imx_v8_defconfig sr_imx_v8_defconfig"
