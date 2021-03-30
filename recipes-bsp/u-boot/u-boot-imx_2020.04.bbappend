FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Add-imx8mp-solidrun-configuration-files-to-u-boot.patch \
	file://0002-Add-imx8mp-solidrun-device-tree-to-u-boot.patch  \
	file://0003-Add-imx8mp-solidrun-board-to-uboot-configuration.patch  \
	file://0004-fix-name-of-dtb-file-for-i.MX8MP-HummingBoard-Pulse.patch  \
	file://0005-imx8mp-add-eqos-ethernet-port-and-disable-fec.patch  \
	file://0006-imx8mp-add-memory-size-detection.patch \
	file://0007-edit-imx8mp-solidrun-mmc-uboot-environment.patch \
	file://0008-imx8mp-Samsung-LPDDR4-uses-a-single-zq-resistor.patch \
"
