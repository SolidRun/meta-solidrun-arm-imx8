FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
KBUILD_DEFCONFIG_mx8 = ""
SRC_URI += " \
	file://sr_imx_v8_defconfig \
	file://0007-ARM64-dts-imx8mp-Add-SolidRun-iMX8MP-SOM-based-platf.patch \
	file://0008-Move-M.2-PCIe-reset-from-M.2-rfkill-to-PCIe-node.patch \
	file://0009-arm64-dts-imx8mp-hummingboard-pulse-add-separate-dtb.patch \
	file://0010-arm64-dts-imx8mp-hummingboard-pulse-swap-m.2-reset-a.patch \
	file://0011-arm64-dts-imx8mp-sr-som-add-second-ethernet-phy.patch \
	file://0012-arm64-dts-add-support-for-imx8mp-hummingboard-extend.patch \
	file://0013-arm64-dts-split-pcie-reset-signals-for-hb-pulse-and-.patch \
	file://0020-arm64-dts-imx8mp-hummingboard-pulse-use-upstream-rfk.patch \
	file://0101-dt-bindings-net-adin-add-pin-polarity-properties-for.patch \
	file://0102-net-phy-adin-add-support-for-setting-led-link-status.patch \
	file://0103-arm64-dts-add-description-for-solidrun-solidsense-n8.patch \
	file://0104-arm64-dts-imx8mn-solidsense-n8-add-power-controls-fo.patch \
	file://0200-arm64-dts-imx8mp-hummingboard-pulse-sync-with-upstre.patch \
"

KERNEL_MODULE_AUTOLOAD += "imx-sdma"
FILES_${PN} += " \
	${sysconfdir}/modules-load.d/imx-sdma.conf \
	file://sr_imx_v8_defconfig \
"
DELTA_KERNEL_DEFCONFIG:append:mx8-nxp-bsp = " imx_v8_defconfig sr_imx_v8_defconfig"
