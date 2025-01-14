# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/2.10-solidrun:"

# Add SolidRun patches
SRC_URI:append = " \
	file://0001-imx8mn-Update-RDC-configuration-for-UART4.patch \
"
