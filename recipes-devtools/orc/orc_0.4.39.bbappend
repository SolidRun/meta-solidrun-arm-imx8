# Add this layer to SRC_URI search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add SolidRun patches
SRC_URI:append = " \
	file://0001-x86-work-around-old-GCC-versions-pre-9.0-having-brok.patch \
"
