# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add SolidRun patches
SRC_URI:append = " \
	file://0001-imx8m-support-including-os-dtbs-fit-image.patch \
"
