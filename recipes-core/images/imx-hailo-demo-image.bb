DESCRIPTION = "Tha Demo image for I.MX8 build with hailo module. \
This creates a very large image, not suitable for production."

LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += " \
    debug-tweaks \
    package-management \
    splash \
    ssh-server-dropbear \
    hwcodecs \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'weston', \
       bb.utils.contains('DISTRO_FEATURES',     'x11', 'x11-base x11-sato', \
                                                       '', d), d)} \
"

CORE_IMAGE_EXTRA_INSTALL += " \
    packagegroup-core-full-cmdline \
    packagegroup-imx-isp \
    packagegroup-fsl-gstreamer1.0 \
    packagegroup-fsl-gstreamer1.0-full \
    firmwared \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 wayland', 'weston-xwayland xterm', '', d)} \
"

# Hailo
CORE_IMAGE_EXTRA_INSTALL += " \
    hailo-firmware libhailort hailortcli hailo-pci libgsthailo \
    libgsthailotools tappas-apps hailo-post-processes tappas-tracers \
"
