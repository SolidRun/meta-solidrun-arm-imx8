FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Add-IMX8MP-device-tree.patch \
	file://0002-Enable-I2C-in-PMIC.patch  \
	file://0003-Add-sound-driver-support-for-imx-wm8904.patch  \
	file://0004-arm64-dts-imx8mp-based-hummingboard-pulse.patch  \
"
