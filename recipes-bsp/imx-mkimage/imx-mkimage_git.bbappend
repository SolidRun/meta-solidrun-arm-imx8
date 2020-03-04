SRCBRANCH = "imx_4.14.78_1.0.0_ga"
SRC_URI = "git://source.codeaurora.org/external/imx/imx-mkimage.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "2cf091c075ea1950afa22a56e224dc4e448db542"

SRC_URI += " \
        file://0001-Modify-dtb-name-to-imx8mm-solidrun.patch \
"
