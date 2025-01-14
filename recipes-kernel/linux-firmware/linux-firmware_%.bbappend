do_install:append () {
	# install bluetooth firmware to /lib/firmware/brcm
	install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link generic firmware and config for SolidSense N8
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd
}

FILES:${PN}-bcm43455:append = " \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.1MW.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd \
"
