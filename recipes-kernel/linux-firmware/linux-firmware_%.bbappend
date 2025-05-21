do_install:append () {
	# install bluetooth firmware to /lib/firmware/brcm
	install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link generic firmware and config for SolidSense N8
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd

	# link generic firmware and config for i.MX8MM HummingBoard Ripple
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.bin
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mm-hummingboard-ripple.hcd

	# link generic firmware and config for i.MX8MP CuBox-M
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-cubox-m.bin
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-cubox-m.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-cubox-m.hcd
}

FILES:${PN}-bcm43455:append = " \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.1MW.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mm-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-cubox-m.hcd \
"
