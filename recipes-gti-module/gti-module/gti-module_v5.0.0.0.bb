SUMMARY = "GyrFalcon kernel module"
DESCRIPTION = "Add gti_pci_drv.ko to rootfs"
HOMEPAGE = ""
LICENSE = "CLOSED"
kmoddir = "/lib/modules/${KERNEL_VERSION}/gti"
SRC_URI += "file://gti_pcie_drv.ko"

PROVIDES="gti-module"
RPROVIDES_${PN} += "gti-module"

FILES_${PN} += "/lib/modules/ ${kmoddir} ${kmoddir}/gti_pcie_drv.ko"

do_install() {
#install -d "${D}/opt/gyrfalcon"
install -d "${D}${kmoddir}"
install -m 0755    ${WORKDIR}/gti_pcie_drv.ko     ${D}${kmoddir}
}


