FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Replace-default-evk.dtb-with-imx8mp-solidrun.dtb.patch \
"
