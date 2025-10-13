# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.6-solidrun:"

# use solidrun fork
LINUX_IMX_SRC:solidrun-imx8 = "git://github.com/SolidRun/linux-stable.git;protocol=https;branch=${SRCBRANCH}"
SRCBRANCH:solidrun-imx8 = "lf-6.6-sr-imx8"
SRCREV:solidrun-imx8 = "4beeaf0e1d5c3ffc848f31e0f2c7077765f3e05f"

# Enable kernel delta configs
# NXP BSP has disabled the normal way of *.scc fragments ...
SRC_URI:append:solidrun-imx8 = " \
	file://kernel-config/10-imx8mm-sr-som.cfg \
	file://kernel-config/10-imx8mp-sr-som.cfg \
	file://kernel-config/10-solidsense-n8.cfg \
"
DELTA_KERNEL_DEFCONFIG:append:imx8mm-sr-som = " kernel-config/10-imx8mm-sr-som.cfg "
DELTA_KERNEL_DEFCONFIG:append:imx8mp-sr-som = " kernel-config/10-imx8mp-sr-som.cfg "
DELTA_KERNEL_DEFCONFIG:append:solidsense-n8 = " kernel-config/10-solidsense-n8.cfg "
