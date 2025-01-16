# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/2024.04-solidrun:"

# Add SolidRun patches
SRC_URI:append = " \
	file://0001-mmc-fsl_esdhc_imx-only-set-vqmmc-regulator-on-voltag.patch \
	file://0002-add-support-for-solidrun-solidsense-n8-board.patch \
	file://0003-board-solidrun-solidsense-n8-fix-phy-detection-runni.patch \
"
