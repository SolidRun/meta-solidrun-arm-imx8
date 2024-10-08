# Power-Sequence for SolidRun i.MX8DXL V2X Carrier Board LTE Module
DESCRIPTION = "lte power-sequence service"
SUMMARY = "lte power-sequence service to reset / enable lte module"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
	file://lte_power.sh \
	file://lte-power.service \
"

do_install () {
    install -m 0755 -D ${WORKDIR}/lte_power.sh ${D}/${sbindir}/lte_power.sh
    install -m 0755 -D ${WORKDIR}/lte-power.service ${D}${systemd_unitdir}/system/lte-power.service
}

SYSTEMD_SERVICE:${PN} = "lte-power.service"
