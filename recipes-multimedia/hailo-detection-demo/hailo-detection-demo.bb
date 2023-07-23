DESCRIPTION = "General detection demo from tappas-apps. \
Capturing video from camera and showing result on HDMI. Autostart on boot. \
This recipe is for demo only."

# To enable this add 'CORE_IMAGE_EXTRA_INSTALL += "hailo-detection-demo"' to your local.conf 

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

REQUIRED_DISTRO_FEATURES += "systemd"

inherit systemd features_check

# Demo image
SRC_URI = "https://hailo-tappas.s3.eu-west-2.amazonaws.com/v3.25/general/hefs/yolov5m_wo_spp_60p.hef;md5sum=3837ea90c4e0a9fff97b6e2e3d1630ab \
            file://general_detection.sh \
            file://hailo-demo.service"

ROOTFS_APPS_DIR = "${D}/home/root/apps"

SYSTEMD_SERVICE:${PN} = "hailo-demo.service"

RDEPENDS:${PN} += "bash tappas-apps weston-init"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    mkdir -p ${ROOTFS_APPS_DIR}/general_detection/resources
    cp ${WORKDIR}/yolov5m_wo_spp_60p.hef ${ROOTFS_APPS_DIR}/general_detection/resources
    install -m 755 ${WORKDIR}/general_detection.sh ${ROOTFS_APPS_DIR}/general_detection/
    
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/hailo-demo.service ${D}${systemd_system_unitdir}
    fi

}

FILES:${PN} += "/home/root/apps/* ${systemd_system_unitdir}/*"
