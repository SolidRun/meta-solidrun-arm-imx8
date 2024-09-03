FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Replace-default-evk.dtb-with-imx8mp-solidrun.dtb.patch \
"

# SolidRun i.MX8DXL SoM has custom SCU Firmware
SC_FIRMWARE_NAME:imx8dxl-sr-som = "mx8dxl-sr-som-scfw-tcm.bin"
