FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

EXTRA_OECONF:append:solidsense-n8 = " --enable-imx_gpio"

SRC_URI:append:solidsense-n8 = " file://solidsense-n8.cfg"

do_install:append:solidsense-n8() {
install -d "${D}${sysconfdir}"
	install -m 0644 -D ${WORKDIR}/solidsense-n8.cfg ${D}${sysconfdir}/${PN}.cfg
}

FILES:${PN}:append:solidsense-n8 = " ${sysconfdir}/${PN}.cfg"
