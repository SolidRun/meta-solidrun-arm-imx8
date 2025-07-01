DESCRIPTION = "udev rules for solidrun devices"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://00-solidrun.rules \
"
FILESEXTRAPATHS:prepend := "${THISDIR}/solidrun-udev-rules:"

do_install() {
	install -v -m 644 -D ${WORKDIR}/00-solidrun.rules ${D}${nonarch_base_libdir}/udev/rules.d/00-solidrun.rules
}

FILES:${PN} = "\
	${nonarch_base_libdir}/udev/rules.d/*.rules \
"
