OpenEmbedded/Yocto BSP layer for SolidRun's iMX8M Plus & Nano based platforms
================================================================

This layer provides support for SolidRun's iMX8M Plus & Nano based platforms for
use with OpenEmbedded and Yocto Freescale's BSP layer.


# Instructions
1. Create working folder for sources and build files:

       mkdir imx-yocto
       cd imx-yocto

2. Get NXP Ycoto sources(require repo app):

       repo init -u https://github.com/SolidRun/meta-solidrun-arm-imx8 -b kirkstone-imx8m -m sr-imx-5.15.71-2.2.0.xml
       repo sync

3. Add the meta-solidrun-arm-imx8 layer (curent git repository) into the sources directory, the directory layout should be like this:

       .
       ├── sources
       │       ├── base
       │       ├── meta-browser
       │       ├──  meta-freescale
       │       ├──  meta-freescale-3rdparty
       │       ├──  meta-freescale-distro
       │       ├──  meta-fsl-bsp-release
       │       ├──  meta-hailo
       │       ├──  meta-openembedded
       │       ├──  meta-qt5
       │       ├──  meta-rust
       │       ├──  meta-solidrun-arm-imx8
       │       ├──  meta-timesys
       │       └── poky
       │
       ├── downloads
       └── ...

4. Configure target machine and distro:

   | MACHINE        | Description                    |
   | -------------- | ------------------------------ |
   | imx8mpsolidrun | All i.MX8M Plus based products |
   | solidsensen8   | SolidSense N8                  |

   Select appropriate machine from the table above, and set in environment:

       # E.g. imx8mpsolidrun:
       MACHINE=imx8mpsolidrun

   | DISTRO           | Description                                             |
   | ---------------- | ------------------------------------------------------- |
   | fsl-imx-fb       | NXP Distro with Framebuffer Graphics                    |
   | fsl-imx-wayland  | NXP Distro with Wayland Graphics                        |
   | fsl-imx-x11      | NXP Distro with X11 Graphics                            |
   | fsl-imx-xwayland | NXP Distro with Wayland Graphics with X11 Compatibility |

   While NXP supports multiple graphical systems, "fsl-imx-xwayland" is recommended for greatest compatibility.
   New designs should consider "fsl-imx-wayland" without X11 compatibility:

       # E.g. fsl-imx-xwayland
       DISTRO=fsl-imx-xwayland

   Configure machine, distro and create build environment:
   **After running the following commands, you need to accept the EULA (scrool down and run "y")**

       DISTRO=$DISTRO MACHINE=$MACHINE source imx-setup-release.sh -b build-$DISTRO-$MACHINE

5. Build Yocto image by running the first, which is a minimal image (lacks firmwares), the second is the full image excluding demos, and the third builds the demos for the full image build:
(**The following command can take several hours**)

       bitbake core-image-minimal
       bitbake imx-image-full
       bitbake imx-hailo-demo-image

   The image will be ready at tmp/deploy/images/imx8mpsolidrun and should look as follow:

       tmp/deploy/images/imx8mpsolidrun/core-image-minimal-imx8mpsolidrun.wic.zst

   or

       tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.zst

   To flash the image to a micro SD run -

       zstd -d -c tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.zst | sudo dd of=/dev/sdX bs=1M

   Or for a multi-core machine this can done faster using

       pzstd -d -c tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.zst | sudo dd of=/dev/sdX bs=4M conv=fsync

   (**Notice that /dev/sdX is the block device points to your micro SD**)


# Instructions for building under docker container
Since this release of Yocto doesn't support latest disribution releases the following
instructions provides information how to build under a container.

When performing this the following is valid -
1. The contained build environment and the user's workdir is shared under same UID and GUID
2. The user can build inside the container, but deploy on a micro SD, eMMC or anything else outside of the container.

## Create a new image called yocto-build-image based on ubuntu-18.04

Follow the commands below to; first clone this branch and run the following command only once -

    cd docker
    docker build --tag yocto-build-image:latest .

## Spin a container and mount your working directory into it

    docker run --rm -it -v "$PWD":/home/build/work/imx8mp/ yocto-build-image:latest /bin/bash
    git config --global user.name "Your Name"
    git config --global user.email "you@example.com"
    wget https://storage.googleapis.com/git-repo-downloads/repo
    chmod a+x repo

and then follow the above instructions on how to build (**Notice that /home/<username>/work/imx8mp directory now is shared between the container and the outside deplelopment environment**)

## Performance increase building source with LTO enabled

To achieve better performance on the platform you can enable building the source with LTO (Link Time Optimization) enabled. To do this add the following lines to your local.conf

    require conf/distro/include/lto.inc
    DISTRO_FEATURES:append = " lto"

## Include NetworkManager and ModemManager for network control
If you prefer to use NetworkManager and ModemManager rather than the default Yocto configuration of connman and ofono please add the following snippet to your local.conf:

    IMAGE_INSTALL_remove += " ofono connman connman-gnome connman-conf"
    IMAGE_INSTALL_remove += " packagegroup-core-tools-testapps"
    PACKAGE_EXCLUDE += "ofono connman connman-gnome connman-conf"
    PACKAGE_EXCLUDE += "connman-client connman-tools"
    PACKAGE_EXCLUDE += "packagegroup-core-tools-testapps"
    DISTRO_FEATURES_remove = " 3g"
    IMAGE_INSTALL_append = " networkmanager networkmanager-nmcli modemmanager"
    IMAGE_INSTALL_append = " networkmanager-bash-completion"
    PACKAGECONFIG_append_pn-networkmanager = " modemmanager ppp"

## Enabling Mender

You can enable mender OTA with these steps:

1. Add mender-core to bblayers.conf:

       BBLAYERS += "${BSPDIR}/sources/meta-mender/meta-mender-core"

2. Configure mender. You can find sample configuration in `conf/sample/local.conf.mender.sample`

# Usage Hints

## Connecting to WiFi

### systemd-networkd

`core-image-*` images come with systemd-networkd by default.
For connecting to a protected WiFi network using WPA:

1. ensure image includes `wpa_supplicant`:

       IMAGE_INSTALL_append = " wpa-supplicant"

2. create wpa config file `/etc/wpa_supplicant/wpa_supplicant-wlan0.conf`:

       mkdir -p /etc/wpa_supplicant
       wpa_passphrase <SSID> > /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
       # reading passphrase from stdin
       <type password>
       cat /etc/wpa_supplicant.conf

3. configure wlan0 interface, create `/etc/systemd/network/00-wlan0.network`:

       [Match]
       Name=wlan0

       [Network]
       DHCP=yes

3. enable interface:

       networkctl reload
       systemctl enable --now wpa_supplicant@wlan0.service
