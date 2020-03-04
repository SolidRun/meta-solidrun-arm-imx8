# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2018 (C) O.S. Systems Software LTDA.
# Copyright 2017-2019 NXP

#DESCRIPTION = "i.MX U-Boot suppporting i.MX reference boards."
#require recipes-bsp/u-boot/u-boot.inc

#PROVIDES += "u-boot"

#LICENSE = "GPLv2+"
#LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRCBRANCH = "imx_v2018.03_4.14.78_1.0.0_ga"
SRC_URI = "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "7ade5b407fe6164c0d07f32f72e487ae5f6f3964"


SRC_URI += " \
        file://0001-imx8mm-add-SolidRun-i.mx8mm-SOM.patch \
	file://0002-imx8mm-add-SolidRun-SOM-defconfig.patch  \
	file://0003-imx8mm-add-SolidRun-config-header-file.patch  \
	file://0004-imx8mm-initial-commit-for-SolidRun-SOM-board.patch  \
	file://0005-imx8mm-add-SolidRun-SOM-device-tree.patch  \
	file://0006-Add-DSI-support-for-uboot-change-to-right-addresess.patch  \
	file://0007-Add-distro-bootcmd-support.patch  \
	file://0008-Change-imx8mm_solidrun_defconfig-to-support-distro.patch  \
"

