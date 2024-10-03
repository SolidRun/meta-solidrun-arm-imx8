FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
KBUILD_DEFCONFIG_mx8 = ""
SRC_URI += " \
	file://sr_imx_v8_defconfig \
	file://0001-gpio-vf610-Fix-missing-include-for-pinctrl_.patch \
	file://0002-drm-bridge-it6161-Build-fix-for-a10ae796.patch \
	file://0003-ASoC-SOF-Add-missing-include-for-arm_smccc_smc.patch \
	file://0004-regulator-pca9450-Add-dt-property-pca-i2c-lt-en.patch \
	file://0005-net-rfkill-gpio-add-device-tree-support.patch \
	file://0006-regulator-userspace-consumer-add-DT-support.patch \
	file://0007-ARM64-dts-imx8mp-Add-SolidRun-iMX8MP-SOM-based-platf.patch \
	file://0008-Move-M.2-PCIe-reset-from-M.2-rfkill-to-PCIe-node.patch \
	file://0009-arm64-dts-imx8mp-hummingboard-pulse-add-separate-dtb.patch \
	file://0010-arm64-dts-imx8mp-hummingboard-pulse-swap-m.2-reset-a.patch \
	file://0011-arm64-dts-imx8mp-sr-som-add-second-ethernet-phy.patch \
	file://0012-arm64-dts-add-support-for-imx8mp-hummingboard-extend.patch \
	file://0013-arm64-dts-split-pcie-reset-signals-for-hb-pulse-and-.patch \
	file://0014-adv7511-driver-update.patch \
	file://0016-Revert-net-rfkill-gpio-add-device-tree-support.patch \
	file://0017-net-rfkill-gpio-add-DT-support.patch \
	file://0018-net-rfkill-gpio-prevent-value-glitch-during-probe.patch \
	file://0019-net-rfkill-gpio-set-GPIO-direction.patch \
	file://0020-arm64-dts-imx8mp-hummingboard-pulse-use-upstream-rfk.patch \
	file://0100-dt-bindings-net-adin-document-phy-clock-output-prope.patch \
	file://0101-dt-bindings-net-adin-add-pin-polarity-properties-for.patch \
	file://0102-net-phy-adin-add-support-for-setting-led-link-status.patch \
	file://0103-arm64-dts-add-description-for-solidrun-solidsense-n8.patch \
	file://0104-arm64-dts-imx8mn-solidsense-n8-add-power-controls-fo.patch \
	file://0105-arm64-dts-imx8mn-solidsense-n8-set-bluetooth-max-bau.patch \
	file://0106-arm64-dts-imx8mn-solidsense-n8-set-bluetooth-max-bau.patch \
	file://0200-net-dsa-sja1105-read-and-save-the-silicon-revision.patch \
	file://0201-net-dsa-sja1105-disallow-C45-transactions-on-the-BAS.patch \
	file://0202-net-phy-add-basic-driver-for-NXP-CBTX-PHY.patch \
	file://0203-arm64-dts-imx8-ss-increase-lpspi0-base-clock.patch \
	file://0204-HACK-spi-lpspi-support-two-chip-selects.patch \
	file://0205-arm64-dts-Add-SolidRun-V2X-SoM-and-Carrier.patch \
	file://0207-arm64-dts-imx8dxl-sr-som-add-userspace-consumer-node.patch \
	file://0208-arm64-dts-imx8dxl-sr-som-switch-lpspi2-chipselect-to.patch \
	file://0209-arm64-dts-imx8dxl-sr-som-sxf1800-change-maximum-freq.patch \
	file://0210-SDHCI-ESDHC-Add-quirks-patch-for-32bit-unaligned-mes.patch \
	file://0211-arm64-dts-imx8dxl-v2x-update-wifi-enable-gpio-for-ca.patch \
	file://0212-dt-bindings-rtc-ds1307-Add-support-for-Epson-RX8111.patch \
	file://0213-rtc-ds1307-Add-support-for-Epson-RX8111.patch \
	file://0214-arm64-dts-imx8dxl-v2x-split-carrier-into-separate-dt.patch \
	file://0215-iio-st_pressure-initial-lps22qs-support.patch \
	file://0216-arm64-dts-imx8dxl-v2x-add-solidrun-v2x-carrier-revis.patch \
	file://0217-arm64-dts-imx8dxl-v2x-v11-fix-interrupt-support-for-.patch \
	file://0218-arm64-dts-imx8dxl-v2x-re-enable-lte-vbat-node-and-cl.patch \
	file://0219-arm64-dts-imx8dxl-v2x-enable-power-for-lte-vbat-user.patch \
	file://0220-arm64-dts-imx8dxl-v2x-configure-pins-for-i2c-bus-rec.patch \
	file://0221-arm64-dts-imx8dxl-v2x-v11-fix-pinmux-setting-for-usb.patch \
	file://0222-arm64-dts-imx8dxl-v2x-v11-enable-rtc-backup-battery-.patch \
	file://0223-arm64-dts-add-solidrun-v2x-gateway-with-som-revision.patch \
	file://0224-arm64-dts-imx8dxl-v2x-add-pinmux-for-ethernet-switch.patch \
	file://0226-arm64-dts-imx8dxl-sr-som-enable-edma3-for-lpi2c.patch \
	file://0227-arm64-dts-imx8dxl-sr-som-set-i2c-gpios-open-drain.patch \
	file://0228-arm64-dts-imx8dxl-v2x-add-pull-up-for-lte-module-ope.patch \
	file://0229-arm64-dts-imx8dxl-v2x-limit-bluetooth-uart-to-3Mbaud.patch \
"

KERNEL_MODULE_AUTOLOAD += "imx-sdma"
FILES_${PN} += " \
	${sysconfdir}/modules-load.d/imx-sdma.conf \
	file://sr_imx_v8_defconfig \
"
DELTA_KERNEL_DEFCONFIG:append:mx8-nxp-bsp = " imx_v8_defconfig sr_imx_v8_defconfig"
