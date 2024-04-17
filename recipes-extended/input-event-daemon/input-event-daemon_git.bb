DESCRIPTION = "input event handling daemon for linux"

LICENSE = "COFFEE-WARE"
LICENSE_PATH += "${LAYERDIR}/custom-licenses"
LIC_FILES_CHKSUM = "file://README;md5=2dbf5d639fbb8b941fbc567e5a085758"

SRC_URI = " \
	git://github.com/gandro/input-event-daemon;protocol=https;branch=${SRCBRANCH} \
	file://input-event-daemon.init \
	file://input-event-daemon.service \
"
SRCBRANCH = "master"
SRCREV = "8b0c8f117e093b89927cf966c008954a11717e10"

S = "${WORKDIR}/git"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit systemd update-rc.d

SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_SERVICE:${PN} = "${PN}.service"
INITSCRIPT_NAME = "${PN}"
INITSCRIPT_PARAMS = "defaults"

do_install() {
	oe_runmake DESTDIR=${D} install
	install -d "${D}${sysconfdir}/init.d"
	install -m 755 -D "${WORKDIR}/${PN}.init" "${D}${sysconfdir}/init.d/${PN}"
	install -m 0644 -D ${WORKDIR}/${PN}.service ${D}${systemd_system_unitdir}/${PN}.service
}

SRC_URI:append:solidsensen8 = " file://solidsense-n8.conf"

do_install:append:solidsensen8() {
install -d "${D}${sysconfdir}/init.d"
	install -m 0644 -D ${WORKDIR}/solidsense-n8.conf ${D}${sysconfdir}/${PN}.conf
}
