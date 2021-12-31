FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx:"
PATCHTOOL = "git"

PROVIDES += "u-boot-fw-utils"
RPROVIDES_${PN} += "u-boot-fw-utils"
UBOOT_SRC ?= "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2020.04_5.4.70_2.3.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH} \
"
SRCREV = "e42dee801ec55bc40347cbb98f13bfb5899f0368"

SRC_URI += " \
        file://0001-Add-imx8mp-solidrun-configuration-files-to-u-boot.patch \
        file://0002-Add-imx8mp-solidrun-device-tree-to-u-boot.patch  \
        file://0003-Add-imx8mp-solidrun-board-to-uboot-configuration.patch  \
        file://0004-fix-name-of-dtb-file-for-i.MX8MP-HummingBoard-Pulse.patch  \
        file://0005-imx8mp-add-eqos-ethernet-port-and-disable-fec.patch  \
        file://0006-imx8mp-add-memory-size-detection.patch \
        file://0007-edit-imx8mp-solidrun-mmc-uboot-environment.patch \
        file://0008-imx8mp-Samsung-LPDDR4-uses-a-single-zq-resistor.patch \
"
SRC_URI += "file://fw_env.config"

do_install_append() {
    install -Dm 0644 ${WORKDIR}/fw_env.config   ${D}${sysconfdir}/fw_env.config
}

FILES_${PN} += "${sysconfdir}/fw_env.config"

