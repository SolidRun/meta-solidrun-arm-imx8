SUMMARY = "SolidRun i.MX8 Firmware"
DESCRIPTION = "Firmware for SolidRun i.MX8 Family Products"
SECTION = "kernel"
LICENSE = "Firmware-cypress-murata"

BT_1MW_FWVER="003.001.025.0187.0366.1MW"
BT_2FY_FWVER="001.002.032.0205.0067_TDM1_CE"

SRC_URI = "git://github.com/SolidRun/imx8mp_build.git;protocol=https;branch=develop-lf-6.6.52-2.2.0-imx8mp"
SRCREV = "68e87c8243dc0e957cce7f239a65f9210ac5ed08"

LIC_FILES_CHKSUM = "file://overlay/buildroot/usr/lib/firmware/cypress/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

S = "${WORKDIR}/git"

do_install:append () {
	# create destination directories
	install -v -m755 -d ${D}${nonarch_base_libdir}/firmware/brcm
	install -v -m755 -d ${D}${nonarch_base_libdir}/firmware/cypress

	# install copyright notice
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/LICENCE.cypress ${D}${nonarch_base_libdir}/firmware/LICENCE.cypress_murata

	# install wifi firmware to /lib/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.trxse ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress

	# install bluetooth firmware to /lib/firmware/brcm
	install -m 0644 overlay/buildroot/usr/lib/firmware/brcm/BCM4345C0_${BT_1MW_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm
	install -m 0644 overlay/buildroot/usr/lib/firmware/brcm/CYW55500A1_${BT_2FY_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm

	# link 1MW firmware and configs for boards with 1MW and common WiFi module design:
	# - i.MX8MM SoM
	# - i.MX8MP SoM
	# - SolidSense N8
	for board in solidrun,imx8mm-hummingboard-ripple solidrun,imx8mp-cubox-m solidrun,imx8mp-hummingboard-iiot solidrun,imx8mp-hummingboard-mate solidrun,imx8mp-hummingboard-pulse solidrun,imx8mp-hummingboard-pro solidrun,imx8mp-hummingboard-ripple solidrun,solidsense-n8-compact; do
		# Murata 1MW WiFi/BT
		ln -sv cyfmac43455-sdio.solidrun,imx8mp-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.bin
		ln -sv cyfmac43455-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.clm_blob
		ln -sv cyfmac43455-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.$board.txt
		ln -sv BCM4345C0_${BT_1MW_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.$board.hcd
	done

	# link 2FY firmware and configs for boards with 2FY and common WiFi module design:
	# - i.MX8MP SoM
	for board in solidrun,imx8mp-cubox-m solidrun,imx8mp-hummingboard-iiot solidrun,imx8mp-hummingboard-mate solidrun,imx8mp-hummingboard-pulse solidrun,imx8mp-hummingboard-pro solidrun,imx8mp-hummingboard-ripple; do
		# Murata 2FY WiFi/BT
		ln -sv cyfmac55500-sdio.solidrun,imx8mp-sr-som.trxse ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.$board.trxse
		ln -sv cyfmac55500-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.$board.clm_blob
		ln -sv cyfmac55500-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.$board.txt
		ln -sv CYW55500A1_${BT_2FY_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM55500A1.$board.hcd
	done
}

PACKAGES += " ${PN}-cypress-murata-license "
LICENSE:${PN}-cypress-murata-license = "Firmware-cypress-murata"
NO_GENERIC_LICENSE[Firmware-cypress-murata] = "overlay/buildroot/usr/lib/firmware/cypress/LICENCE.cypress"
FILES:${PN}-cypress-murata-license = "${nonarch_base_libdir}/firmware/LICENCE.cypress_murata"

PACKAGES += " ${PN}-cyw43455 "
LICENSE:${PN}-cyw43455 = "Firmware-cypress-murata"
FILES:${PN}-cyw43455 = " \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0_${BT_1MW_FWVER}.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mm-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-cubox-m.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-mate.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pulse.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,imx8mp-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM4345C0.solidrun,solidsense-n8-compact.hcd \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-cubox-m.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mm-hummingboard-ripple.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-hummingboard-mate.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-hummingboard-pulse.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-hummingboard-ripple.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac43455-sdio.solidrun,solidsense-n8-compact.* \
"

PACKAGES += " ${PN}-cyw55500 "
LICENSE:${PN}-cyw55500 = "Firmware-cypress-murata"
FILES:${PN}-cyw55500 = " \
	${nonarch_base_libdir}/firmware/brcm/CYW55500A1_${BT_2FY_FWVER}.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-cubox-m.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-hummingboard-iiot.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-hummingboard-mate.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-hummingboard-pulse.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-hummingboard-pro.hcd \
	${nonarch_base_libdir}/firmware/brcm/BCM55500A1.solidrun,imx8mp-hummingboard-ripple.hcd \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-cubox-m.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-hummingboard-iiot.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-hummingboard-mate.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-hummingboard-pulse.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-hummingboard-pro.* \
	${nonarch_base_libdir}/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-hummingboard-ripple.* \
"
