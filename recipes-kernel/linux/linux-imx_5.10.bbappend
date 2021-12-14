FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Add-imx8mp-device-tree.patch \
	file://0002-arch-arm64-dts-add-imx8mp-based-hummingboard-pulse-d.patch \
	file://0003-arm64-dts-imx8mp-based-hummingboard-pulse.patch \
	file://0004-arm64-dts-imx8mp-Edit-imx8mp-hummingboard-pulse-release-pcie-reset.patch \
	file://0005-arm64-dts-imx8mp-move-to-kernel-5.10-based-release.patch \
	file://0006-arch-arm64-build-brcmfmac-as-a-module.patch \
	file://0007-arch-arm64-imx8mpsolidrun-fix-bluetooth-bt_reg_on.patch \
"
