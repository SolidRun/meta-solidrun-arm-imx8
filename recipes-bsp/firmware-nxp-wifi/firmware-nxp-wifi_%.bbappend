# Copyright 2017-2021 NXP

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PACKAGES =+ " ${PN}-bcm43455-sr"

S = "${WORKDIR}/git"

do_install:append () {
    install -d ${D}${nonarch_base_libdir}/firmware/brcm

    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.bin
    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.bin
    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm
    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.fsl,imx8mp-sr-som.txt
    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.solidrun,solidsense-n8-compact.txt
    install -m 0644 ${S}/cyw-wifi-bt/1MW_CYW43455/BCM4345C0.1MW.hcd ${D}${nonarch_base_libdir}/firmware/brcm/BCM4345C0.hcd
}

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
