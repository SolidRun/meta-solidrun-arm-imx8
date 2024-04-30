FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

EXTRA_OECONF:append:solidsensen8 = " --enable-imx_gpio"

SRC_URI:append:solidsensen8 = " file://solidsense-n8.cfg"

do_install:append:solidsensen8() {
install -d "${D}${sysconfdir}"
	install -m 0644 -D ${WORKDIR}/solidsense-n8.cfg ${D}${sysconfdir}/${PN}.cfg
}

FILES:${PN}:append:solidsensen8 = " ${sysconfdir}/${PN}.cfg"
