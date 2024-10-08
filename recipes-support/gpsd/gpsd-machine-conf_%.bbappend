FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:imx8dxl-sr-som = " \
           file://imx8dxl-sr-som.conf \
"

inherit update-alternatives

ALTERNATIVE:${PN}:imx8dxl-sr-som = "gpsd-defaults"
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.machine"
ALTERNATIVE_PRIORITY[gpsd-defaults] = "15"

do_install:imx8dxl-sr-som() {
    install -d ${D}/${sysconfdir}/default
    install -m 0644 ${WORKDIR}/imx8dxl-sr-som.conf ${D}/${sysconfdir}/default/gpsd.machine
}
