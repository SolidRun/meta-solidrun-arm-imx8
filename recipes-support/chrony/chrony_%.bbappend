# override chrony.conf for imx8dxl som
FILESEXTRAPATHS:prepend:imx8dxl-sr-som := "${THISDIR}/files:"

# add systemd service pps dependency
do_install:append:imx8dxl-sr-som() {
	printf "\n[Unit]\nAfter=dev-pps0.device\nWants=dev-pps0.device\n" >> ${D}${systemd_unitdir}/system/chronyd.service
}
