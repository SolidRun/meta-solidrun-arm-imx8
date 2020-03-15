# Based on linux-yocto-custom.bb
inherit kernel
require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KERNEL_IMAGETYPE = "Image"
KCONFIG_MODE = "--alldefconfig"

SRCBRANCH = "imx_4.19.35_1.1.0"
SRC_URI = "git://source.codeaurora.org/external/imx/linux-imx;protocol=https;branch=${SRCBRANCH} \
           file://defconfig \
"
LINUX_VERSION ?= "4.19.35"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

SRCREV = "0f9917c56d5995e1dc3bde5658e2d7bc865464de"


KERNEL_DEVICETREE_imx8mm = " \
	freescale/fsl-imx8mm-solidrun.dtb \
	"

SRC_URI += " \
	file://imx8mm_kernel_fragment_file.cfg \
	file://0001-Add-imx8mm-solidrun-device-tree.patch \
	file://0002-Fix-PCIe-disable-gpio-search.patch \
	file://0003-pci-spr2803-hack-pcie-resources-allocation.patch	\
	"


DEFAULT_PREFERENCE = "1"
COMPATIBLE_MACHINE = "(mx8|mx8m|mx8mm)"
