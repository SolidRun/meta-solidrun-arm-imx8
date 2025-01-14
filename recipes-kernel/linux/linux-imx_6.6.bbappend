# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/6.6-solidrun:"

# Add SolidRun patches
SRC_URI:append = " \
	file://kernel-config/10-solidsense-n8.cfg \
	file://0001-arm64-dts-add-description-for-solidrun-solidsense-n8.patch \
"

# Enable kernel delta configs
# NXP BSP has disabled the normal way of *.scc fragments ...
DELTA_KERNEL_DEFCONFIG:append = " kernel-config/10-solidsense-n8.cfg "
