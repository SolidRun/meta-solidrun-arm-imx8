FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0001-add-missing-cstdint-for-uint16_t.patch \
"
