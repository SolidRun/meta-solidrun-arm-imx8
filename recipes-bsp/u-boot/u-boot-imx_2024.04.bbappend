# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/2024.04-solidrun:"

# Add SolidRun patches
SRC_URI:append:imx8mm-sr-som = " \
	file://0101-imx8m-change-imx8-soc-board_fix_fdt-weak-to-allow-bo.patch \
	file://0102-add-support-for-solidrun-imx8mm-som-on-hummingboard-.patch \
	file://0103-phy-nop-phy-assert-reset-gpio-during-nop_phy_init.patch \
	file://0104-arm-dts-imx8mm-hummingboard-ripple-support-usb-hub-a.patch \
"
SRC_URI:append:solidsense-n8 = " \
	file://0001-mmc-fsl_esdhc_imx-only-set-vqmmc-regulator-on-voltag.patch \
	file://0002-add-support-for-solidrun-solidsense-n8-board.patch \
	file://0003-board-solidrun-solidsense-n8-fix-phy-detection-runni.patch \
"

# use solidrun fork
UBOOT_SRC:imx8mp-sr-som = "git://github.com/SolidRun/u-boot.git;protocol=https"
SRCBRANCH:imx8mp-sr-som = "lf-6.6.52-2.2.0-sr-imx8"
SRCREV:imx8mp-sr-som = "4d9ab49f4bc3730fbe310892943dd6844a55791a"
