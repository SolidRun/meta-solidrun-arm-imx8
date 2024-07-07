# Copyright 2017-2021 NXP

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

IMX_FIRMWARE_SRC ?= "git://github.com/NXP/imx-firmware.git;protocol=https"
SRCBRANCH_imx-firmware = "lf-6.6.23_2.0.0"
SRC_URI += " \
    git://github.com/murata-wireless/qca-linux-calibration.git;protocol=https;branch=master;name=murata-qca;destsuffix=murata-qca \
    ${IMX_FIRMWARE_SRC};branch=${SRCBRANCH_imx-firmware};destsuffix=imx-firmware;name=imx-firmware \
"

SRCREV_murata-qca = "a0026b646ce6adfb72f135ffa8a310f3614b2272"
SRCREV_imx-firmware = "7e038c6afba3118bcee91608764ac3c633bce0c4"

SRCREV_FORMAT = "default_murata-qca_imx-firmware"

PACKAGES =+ " ${PN}-bcm43455-sr"
# Use the latest version of sdma firmware in firmware-imx
PACKAGES:remove = " ${PN}-imx-sdma-license ${PN}-imx-sdma-imx6q ${PN}-imx-sdma-imx7d"

do_install:append () {
    # Use Murata's QCA calibration files
    install -m 0644 ${WORKDIR}/murata-qca/1CQ/board.bin ${D}${nonarch_base_libdir}/firmware/ath10k/QCA6174/hw3.0/

    # No need to do install for imx sdma binaries
    if [ -d ${D}${base_libdir}/firmware/imx/sdma ]; then
        rm -rf ${D}${base_libdir}/firmware/imx/sdma
    fi

    install -d ${D}${sysconfdir}/firmware

    # Install Murata CYW43455 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.bin
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.txt
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt
    install -m 0644 ${WORKDIR}/imx-firmware/cyw-wifi-bt/1MW_CYW43455/BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.hcd
}

LICENSE:${PN}-bcm43455-sr = "Firmware-broadcom_bcm43xx"
RDEPENDS:${PN}-bcm43455-sr += "${PN}-broadcom-license"

FILES:${PN}-bcm43455:append = " \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.bin \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.clm_blob \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.txt \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt \
       ${nonarch_base_libdir}/firmware/brcm/BCM4345C0.hcd \
"

FILES:${PN}-bcm43455-sr = " \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.bin \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.clm_blob \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.txt \
       ${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt \
       ${nonarch_base_libdir}/firmware/brcm/BCM4345C0.hcd \
"

RCONFLICTS:${PN}-bcm43455 = "${PN}-bcm43455-sr"
RCONFLICTS:${PN}-bcm43455-sr = "${PN}-bcm43455"
