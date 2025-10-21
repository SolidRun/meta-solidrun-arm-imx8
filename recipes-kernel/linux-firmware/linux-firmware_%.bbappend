BT_1MW_FWVER="003.001.025.0187.0366.1MW"
BT_2FY_FWVER="001.002.032.0205.0067_TDM1_CE"
SRC_URI:append = " \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/LICENCE.cypress;downloadfilename=LICENCE.cypress_murata;name=cylic \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.bin;name=1mwbin \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.clm_blob;name=1mwblob \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac43455-sdio.solidrun,imx8mp-sr-som.txt;name=1mwtxt \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/brcm/BCM4345C0_${BT_1MW_FWVER}.hcd;name=1mwhcd \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.trxse;name=2fybin \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.clm_blob;name=2fyblob \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/cypress/cyfmac55500-sdio.solidrun,imx8mp-sr-som.txt;name=2fytxt \
		  https://raw.githubusercontent.com/SolidRun/imx8mp_build/refs/heads/develop-lf-6.6.52-2.2.0-imx8mp/overlay/buildroot/usr/lib/firmware/brcm/CYW55500A1_${BT_2FY_FWVER}.hcd;name=2fyhcd \
"

SRC_URI[cylic.sha256sum] = "3a892759b73e8b459f1a750954b316118b0061fd9d1868d11fa258c104ee7e0c"
SRC_URI[1mwbin.sha256sum] = "c1f854098929ae9bd4481b65221672092d2112cd5fee0f0e5ce01186aa20344e"
SRC_URI[1mwblob.sha256sum] = "e3bc88a33bf55372b31654d5ab7a67db158c0c7328bc9abec8eecc8cb9002af1"
SRC_URI[1mwtxt.sha256sum] = "84f61ce3722325ccb7d1d7ecf4b48b160923df511ed86729ed9656854ebd79cc"
SRC_URI[1mwhcd.sha256sum] = "c903509c43baf812283fbd10c65faab3b0735e09bd57c5a9e9aa97cf3f274d3b"
SRC_URI[2fybin.sha256sum] = "4a03da2e0cb749f3a7dc34c3b5fe056a3bb86f1bd5a46879341c6c92d166c005"
SRC_URI[2fyblob.sha256sum] = "6e8662d1a7a24a23d251e3aef81b82644dd96a939ddfb10d392e923c9217f1f7"
SRC_URI[2fytxt.sha256sum] = "035f090c2b739e3909a856eaf53c99f32f33a2952213caeebdd88a8e9a452c0d"
SRC_URI[2fyhcd.sha256sum] = "47326f9ffcc4836a13015b699222f058d145b2b25f842303a873ecec5ea25be6"

do_install:append () {
	# install copyright notice
	install -m 0644 ${WORKDIR}/LICENCE.cypress_murata ${D}${nonarch_base_libdir}/firmware

	# install wifi firmware to /lib/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43455-sdio.solidrun,imx8mp-sr-som.bin ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43455-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac43455-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac55500-sdio.solidrun,imx8mp-sr-som.trxse ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac55500-sdio.solidrun,imx8mp-sr-som.clm_blob ${D}${nonarch_base_libdir}/firmware/cypress
	install -m 0644 ${WORKDIR}/cyfmac55500-sdio.solidrun,imx8mp-sr-som.txt ${D}${nonarch_base_libdir}/firmware/cypress

	# install bluetooth firmware to /lib/firmware/brcm
	install -m 0644 ${WORKDIR}/BCM4345C0_${BT_1MW_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm
	install -m 0644 ${WORKDIR}/CYW55500A1_${BT_2FY_FWVER}.hcd ${D}${nonarch_base_libdir}/firmware/brcm

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

LICENSE:append = "    & Firmware-cypress-murata "
PACKAGES =+ " ${PN}-cypress-murata-license "
LICENSE:${PN}-cypress-murata-license = "Firmware-cypress-murata"
NO_GENERIC_LICENSE[Firmware-cypress-murata] = "../LICENCE.cypress_murata"
LIC_FILES_CHKSUM:append = " file://../LICENCE.cypress_murata;md5=cbc5f665d04f741f1e006d2096236ba7 "
FILES:${PN}-cypress-murata-license = "${nonarch_base_libdir}/firmware/LICENCE.cypress_murata"

PACKAGES =+ " ${PN}-cyw43455-sr "
LICENSE:${PN}-cyw43455-sr = "Firmware-cypress-murata"
RDEPENDS:${PN}-cyw43455-sr += "${PN}-cypress-murata-license"
FILES:${PN}-cyw43455-sr = " \
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

PACKAGES =+ " ${PN}-cyw55500-sr "
LICENSE:${PN}-cyw55500-sr = "Firmware-cypress-murata"
RDEPENDS:${PN}-cyw55500-sr += "${PN}-cypress-murata-license"
FILES:${PN}-cyw55500-sr = " \
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
