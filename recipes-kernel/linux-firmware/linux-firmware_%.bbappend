do_install:append () {
	# install bluetooth firmware to /lib/firmware/brcm
	install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link generic firmware and config for SolidSense N8
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd

	# link generic firmware and config for i.MX8MM HummingBoard Ripple
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mm-hummingboard-ripple.hcd

	# link generic firmware and config for i.MX8MP CuBox-M
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-cubox-m.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-cubox-m.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-cubox-m.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-cubox-m.hcd

	# link generic firmware and config for i.MX8MP HummingBoard IIoT
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-iiot.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-iiot.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-iiot.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-iiot.hcd

	# link generic firmware and config for i.MX8MP HummingBoard Mate
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-mate.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-mate.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-mate.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-mate.hcd

	# link generic firmware and config for i.MX8MP HummingBoard Pulse
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pulse.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pulse.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pulse.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pulse.hcd

	# link generic firmware and config for i.MX8MP HummingBoard Pro
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pro.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pro.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-pro.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pro.hcd

	# link generic firmware and config for i.MX8MP HummingBoard Ripple
	ln -sv brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-ripple.bin
	ln -sv brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-ripple.clm_blob
	ln -sv brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,imx8mp-hummingboard-ripple.txt
	ln -sv BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-ripple.hcd
}

FILES:${PN}-bcm43455:append = " \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.1MW.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mm-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-cubox-m.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-mate.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pulse.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-ripple.hcd \
"
