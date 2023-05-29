FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://0001-Add-imx8mp-build-target.patch \
"

IMX_PLATFORM:mx8mp-nxp-bsp = "imx8mp"
