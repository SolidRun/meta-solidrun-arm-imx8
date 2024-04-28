# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 (C) O.S. Systems Software LTDA.
# Copyright 2017-2022 NXP

require recipes-bsp/u-boot/u-boot.inc

###############################################################
# BEGIN: u-boot-imx-common_${PV}.inc
DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "git://github.com/nxp-imx/uboot-imx;protocol=https;branch=${SRCBRANCH}"
SRCBRANCH = "imx_v2020.04_5.4.70_2.3.0"
LOCALVERSION ?= "-imx_v2020.04_5.4.70_2.3.0"
SRCREV = "3045fd84c4854f4a7ff8f8e40e096028a9e3b309"

DEPENDS += " \
    bc-native \
    bison-native \
    dtc-native \
    flex-native \
    gnutls-native \
    xxd-native \
"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

inherit fsl-u-boot-localversion

BOOT_TOOLS = "imx-boot-tools"

# END: u-boot-imx-common_${PV}.inc
###############################################################

PROVIDES += "u-boot"

inherit uuu_bootloader_tag

UUU_BOOTLOADER             = ""
UUU_BOOTLOADER:mx6-nxp-bsp = "${UBOOT_BINARY}"
UUU_BOOTLOADER:mx7-nxp-bsp = "${UBOOT_BINARY}"
UUU_BOOTLOADER_TAGGED             = ""
UUU_BOOTLOADER_TAGGED:mx6-nxp-bsp = "u-boot-tagged.${UBOOT_SUFFIX}"
UUU_BOOTLOADER_TAGGED:mx7-nxp-bsp = "u-boot-tagged.${UBOOT_SUFFIX}"

do_deploy:append:mx8m-nxp-bsp() {
    # Deploy u-boot-nodtb.bin and fsl-imx8m*-XX.dtb for mkimage to generate boot binary
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    install -d ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/arch/arm/dts/${UBOOT_DTB_NAME}  ${DEPLOYDIR}/${BOOT_TOOLS}
                    install -m 0777 ${B}/${config}/u-boot-nodtb.bin  ${DEPLOYDIR}/${BOOT_TOOLS}/u-boot-nodtb.bin-${MACHINE}-${type}
                fi
            done
            unset  j
        done
        unset  i
    fi
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(mx6-generic-bsp|mx7-generic-bsp|mx8-generic-bsp|mx9-generic-bsp)"

###############################################################
# BEGIN: Changes to u-boot-imx_${PV}.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += " \
file://0001-Add-imx8mn-solidrun-configuration-files-to-u-boot.patch \
file://0002-imx8mn-Add-imx8mn-solidrun-device-tree-to-the-Makfil.patch \
file://0003-imx8mn-Add-imx8mn-solidrun-device-tree.patch \
file://0004-Edit-ethernet-phy-address.patch \
file://0005-imx8mn-Edit-Bootcmd-Env-to-boot-from-SD-card.patch \
file://0006-imx8mn-Edit-Bootcmd-Env-to-enable-the-CAN_ClockOut1.patch \
file://0007-Imx8mn-Add-Reset-to-PHY.patch \
file://0008-Imx8mn-Check-if-power-is-connected-before-booting.patch \
file://0009-IMX8MN-Graceful-reboot-app-improvement.patch \
file://0010-remove-unused-files-for-solidrun-imx8mn.patch \
file://0011-Imx8mn-Add-support-to-read-MAC-Address-from-the-Fuse.patch \
file://0012-imx8mn-solidrun-support-distro-boot.patch \
file://0013-imx8mn-solidrun-rename-fdtfile-to-imx8mn-compact.dtb.patch \
file://0014-imx8mn-solidrun-implement-ethernet-phy-selection.patch \
file://0015-imx8mn-solidrun-regenerate-defconfig.patch \
"

include ${@bb.utils.contains('BBFILE_COLLECTIONS', 'mender', 'u-boot-imx-mender.inc', '', d)}
