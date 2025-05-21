# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.6-solidrun:"

# Add SolidRun patches
SRC_URI:append:imx8mm-sr-som = " \
	file://kernel-config/10-imx8mm-sr-som.cfg \
	file://0101-arm64-dts-add-description-for-solidrun-imx8mm-hummin.patch \
	file://0102-arm64-dts-imx8mm-hummingboard-ripple-support-usb-hub.patch \
"
SRC_URI:append:solidsense-n8 = " \
	file://kernel-config/10-solidsense-n8.cfg \
	file://0001-arm64-dts-add-description-for-solidrun-solidsense-n8.patch \
"
SRC_URI:append:imx8mp-sr-som = " \
	file://kernel-config/10-imx8mp-sr-som.cfg \
"

# use solidrun fork
LINUX_IMX_SRC:imx8mp-sr-som = "git://github.com/SolidRun/linux-stable.git;protocol=https;branch=${SRCBRANCH}"
SRCBRANCH:imx8mp-sr-som = "lf-6.6-sr-imx8"
SRCREV:imx8mp-sr-som = "5acd11794299215728b706e8f02e9db74f3799ee"

# Enable kernel delta configs
# NXP BSP has disabled the normal way of *.scc fragments ...
DELTA_KERNEL_DEFCONFIG:append:imx8mm-sr-som = " kernel-config/10-imx8mm-sr-som.cfg "
DELTA_KERNEL_DEFCONFIG:append:imx8mp-sr-som = " kernel-config/10-imx8mp-sr-som.cfg "
DELTA_KERNEL_DEFCONFIG:append:solidsense-n8 = " kernel-config/10-solidsense-n8.cfg "
