FILESEXTRAPATHS:prepend:imx8dxl-sr-som := "${THISDIR}/files:"

SRC_URI:append:imx8dxl-sr-som := " \
	file://eth0-none.network \
	file://lan1-dhcp.network \
	file://usb0-dhcp.network \
"

# install default network configuration for SolidRun i.MX8DXL SoM
do_install:append:imx8dxl-sr-som() {
	install -m644 -D ${WORKDIR}/lan1-dhcp.network ${D}${sysconfdir}/systemd/network/01-eth0-none.network
	install -m644 -D ${WORKDIR}/lan1-dhcp.network ${D}${sysconfdir}/systemd/network/11-lan1-dhcp.network
	install -m644 -D ${WORKDIR}/usb0-dhcp.network ${D}${sysconfdir}/systemd/network/11-usb0-dhcp.network
}
