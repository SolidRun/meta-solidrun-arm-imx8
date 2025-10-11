DESCRIPTION = "SolidRun U-Blox GPS Setup Tool"
LICENSE = "Apache-2.0"
SECTION = ""
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
           git://github.com/u-blox/ubxlib.git;branch=${SRCBRANCH};protocol=https;name=ubxlib \
           git://github.com/ThrowTheSwitch/Unity.git;branch=master;protocol=https;name=unity;destsuffix=Unity \
           file://0001-disable-werror-on-linux-port.patch \
           file://0002-add-example-app-to-configure-mia-m10q-uart-interface.patch \
           file://gpsd-ubx-setup.conf \
"
SRCBRANCH = "master"
SRCREV_ubxlib = "0237d5d3706ccb17419a8b9eac14bb568e80ad4c"
SRCREV_unity = "cbcd08fa7de711053a3deec6339ee89cad5d2697"

S = "${WORKDIR}/git"

inherit cmake

DEPENDS = "libgpiod"
OECMAKE_SOURCEPATH = "${S}/port/platform/linux/mcu/posix/runner"
UBXLIB_FLAGS = "-DU_CFG_APP_GNSS_UART=2 -DU_CFG_APP_UART_PREFIX=/dev/ttyLP -DU_CFG_APP_FILTER=GnssUartSetup -DU_CFG_ENABLE_LOGGING=0"

do_configure:prepend() {
    export U_FLAGS="${UBXLIB_FLAGS}"
}

do_install() {
    install -v -m755 -D ${B}/ubxlib_test_main ${D}/${sbindir}/ubx-setup
    install -v -m644 -D ${WORKDIR}/gpsd-ubx-setup.conf ${D}${systemd_system_unitdir}/gpsd.service.d/ubx-setup.conf
}

FILES:${PN} += " ${systemd_system_unitdir}/gpsd.service.d/ubx-setup.conf "
