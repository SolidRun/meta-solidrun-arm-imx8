# SolidRun i.MX8 Yocto BSP

This layer provides support for SolidRun's iMX8 based platforms for use with Yocto and NXPs BSP layers:

- [i.MX8M Plus SoM](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/imx8m-plus-som/)

  - [i.MX8 HummingBoard Mate](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#mate)
  - [i.MX8 HummingBoard Pro](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#pro)
  - [i.MX8 HummingBoard Pulse](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#pulse)
  - [i.MX8 HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#ripple)

- [i.MX8X Lite SoM](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/i-mx-8xlite-som/)

  - [i.MX8X Lite HummingBoard](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-imx8-xlite-sbc/)

- [SolidSense N8](https://www.solid-run.com/edge-gateway-solidsense/#compact)

## Build Instructions

### First Build

Start in a **new empty directory** with plenty of free disk space - at least 30GB, Then:

1. Download the build recipes:

   ```
   repo init -u https://github.com/SolidRun/meta-solidrun-arm-imx8 -b kirkstone-imx8m -m sr-imx-5.15.71-2.2.2.xml
   repo sync
   ```

2. Install buildtools (optional):

   To simplify the build dependencies, especially on unsuppored distributions a buildtools tarball may be used:

       pushd sources/poky
       ./scripts/install-buildtools \
       	--with-extended-buildtools \
       	--release yocto-4.0.20 \
       	--installer-version 4.0.20
       popd

   Activate the buildtools in current shell:

       source sources/poky/buildtools/environment-setup-x86_64-pokysdk-linux


3. Configure target machine and distro:

   | MACHINE          | Description                                     |
   | ---------------- | ----------------------------------------------- |
   | imx8dxla1-sr-som | i.MX8X Lite HummingBoard (preview silicon only) |
   | imx8dxlb0-sr-som | i.MX8X Lite HummingBoard                        |
   | imx8mpsolidrun   | All i.MX8M Plus based products                  |
   | solidsensen8     | SolidSense N8                                   |

   Select appropriate machine from the table above, and set in environment:

       # E.g. imx8mpsolidrun:
       MACHINE=imx8mpsolidrun

   | DISTRO           | Description                                             |
   | ---------------- | ------------------------------------------------------- |
   | fsl-imx-wayland  | NXP Distro with Wayland Graphics                        |
   | fsl-imx-xwayland | NXP Distro with Wayland Graphics with X11 Compatibility |

   For greatest compatibility "fsl-imx-xwayland" is recommended.
   New designs should consider "fsl-imx-wayland" without X11 compatibility:

       DISTRO=fsl-imx-xwayland

4. Initialise a build directory with example configuration files based on selected machine and distro, and appropriate shell environment variables:

       MACHINE=$MACHINE DISTRO=$DISTRO source imx-setup-release.sh
       # optionally choose name of build directory
       # source imx-setup-release.sh -b build-custom

   **After this command, you need to accept the EULA (scrool down and run "y")**

4. Build an image:

   | Image                  | Description                                                       |
   | ---------------------- | ----------------------------------------------------------------- |
   | `core-image-minimal`   | Minimal image sufficient to boot (lacks demos and firmware files) |
   | `imx-image-full`       | Full image                                                        |
   | `imx-hailo-demo-image` | Full image with Hailo Demos                                       |

   E.g. to build `imx-image-full`:

       bitbake imx-image-full

   (**This step can take several hours**)

   The final image is created at `<build-directory>/tmp/deploy/images/<machine>/>image>-<machine>.wic.zst`, e.g.:

       tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.zst

### Returning Developers

After the first build when returning on a new day, after terminal or computer reboot, the previous build environment can be restored.
Navigate to the original top directory (containing `sources`, `imx-setup-release.sh`, `setup-environment`, etc.) execute the commands below:

    # optionally activate buildtools
    # source sources/poky/buildtools/environment-setup-x86_64-pokysdk-linux

    # activate build environment for existing build directory
    source setup-environment <build-directory>

## Deploy (Bootloader/OS) imageto target

Deployment instructions are different between products, follow the appropriate sections below:

### i.MX8M Plus & SolidSense N8

These platforms can boot directly from either microSD or eMMC.

#### microSD (OS/Bootloader)

To flash the image to a microSD card:

    sudo bmaptool copy tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.zst /dev/sdX

(**Notice that /dev/sdX must be replaced with the actual block device representing your microSD. Putting the wrong disk will eat your data!**)

#### eMMC

TBD.

### i.MX8X Lite HummingBoard

i.MX8X Lite SoM can only boot from eMMC or USB-OTG, without option to connect microSD card.

#### eMMC (OS)

Installation of generated disk images may be done using USB Mass Storage Gadget Emulation with a PC.
Special care must be taken to protect usb signals of both PC and target:

1. Precautions:

   1. Modify a USB-A to USB-A cable to include a 10k or greater resistor on VDD line

   2. Never operate usb host-mode on the target while USB is connected to a PC,
      in particular do not use u-boot `usb` command.

2. Connect serial console to a PC, then supply power to the board.

3. Interrupt automatic boot at the u-boot timeout prompt:

       Normal Boot
       Hit any key to stop autoboot:  0
       =>

4. Connect PC to Board with the modified Type-A to Type-A cable.

5. Start USB Mass-Storage Gadget Emulation:

       => ums mmc 0
       UMS: LUN 0, dev mmc 0, hwpart 0, sector 0x0, count 0xe90e80
       -

6. Once PC has detected the USB drive, write the built image, e.g.:

       sudo bmaptool copy tmp/deploy/images/imx8dxlb0-sr-som/core-image-v2x-refbsp-imx8dxlb0-sr-som.wic /dev/sdX
       bmaptool: info: discovered bmap file 'tmp/deploy/images/imx8dxlb0-sr-som/core-image-v2x-refbsp-imx8dxlb0-sr-som.wic.bmap'
       bmaptool: info: block map format version 2.0
       bmaptool: info: 36493 blocks of size 4096 (142.6 MiB), mapped 19499 blocks (76.2 MiB or 53.4%)
       bmaptool: info: copying image 'core-image-v2x-refbsp-imx8dxlb0-sr-som.wic' to block device '/dev/sda' using bmap file 'core-image-v2x-refbsp-imx8dxlb0-sr-som.wic.bmap'
       bmaptool: info: 100% copied
       bmaptool: info: synchronizing '/dev/sda'
       bmaptool: info: copying time: 5.4s, copying speed 14.1 MiB/sec

   (**Notice that /dev/sdX must be replaced with the actual block device representing your microSD. Putting the wrong disk will eat your data!**)

7. Press Ctrl+C keys on u-boot console to abort USB Mass-Storage Gadget Emulation,
   then disconnect USB cable.

#### eMMC (Bootloader)

U-Boot must be installed over usb fastboot protocol using NXP [`uuu` application](https://github.com/NXPmicro/mfgtools/releases).

Download the [`flash-uboot.uuu` script](https://raw.githubusercontent.com/SolidRun/imx8dxl_build/develop/flash-uboot.uuu) to the working directory (`bsp/v2x-build`),
then update the path of u-boot binary according to yocto results:

The `flash-uboot.uuu` script should be copied to the working directory (`bsp/v2x-build`), u-boot binary path changed:

    -SDPS: boot -f images/uboot.bin
    +SDPS: boot -f tmp/deploy/images/imx8dxlb0-sr-som/imx-boot-imx8dxlb0-sr-som-emmc.bin-flash_spl

     # if SPL is used, load u-boot stage
     SDPV: delay 1000
    -SDPV: write -f images/uboot.bin -skipspl
    +SDPV: write -f tmp/deploy/images/imx8dxlb0-sr-som/imx-boot-imx8dxlb0-sr-som-emmc.bin-flash_spl -skipspl
     SDPV: jump

     CFG: FB: -vid 0x1fc9 -pid 0x0152
    @@ -12,6 +12,6 @@ CFG: FB: -vid 0x1fc9 -pid 0x0152
     FB: ucmd setenv fastboot_dev mmc
     FB: ucmd setenv mmcdev 0
     FB: ucmd mmc dev 0
    -FB: flash bootloader images/uboot.bin
    +FB: flash bootloader tmp/deploy/images/imx8dxlb0-sr-som/imx-boot-imx8dxlb0-sr-som-emmc.bin-flash_spl
     FB: ucmd mmc partconf 0 0 1 1
     FB: done

Finally follow the stps outlined in [i.MX8DXL Reference BSP](https://github.com/SolidRun/imx8dxl_build?tab=readme-ov-file#flash-only-u-boot-to-emmc).

## Usage Hints

### Performance increase building source with LTO enabled

To achieve better performance on the platform you can enable building the source with LTO (Link Time Optimization) enabled. To do this add the following lines to your local.conf

    require conf/distro/include/lto.inc
    DISTRO_FEATURES:append = " lto"

### Include NetworkManager and ModemManager for network control
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

### Enabling Mender

You can enable mender OTA with these steps:

1. Add mender-core to bblayers.conf:

       BBLAYERS += "${BSPDIR}/sources/meta-mender/meta-mender-core"

2. Configure mender. You can find sample configuration in `conf/sample/local.conf.mender.sample`

### Connecting to WiFi

#### systemd-networkd

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

### V2X (NXP SAF5400 / SXF1800 on i.MX8X Lite SoM)

Due to license restrictions V2X-specific documentation and software are available only to customers who have purchased a [SolidRun i.MX8DXL SoM with DSRC Modem](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/i-mx-8xlite-som/#order-options).
Please create an account on [nxp.com](https://www.nxp.com/), then contact [SolidRun Support](https://www.solid-run.com/contact-us/#technical-support) to facilitate access through your nxp user account.

## Known Issues

### Failed to spawn fakeroot worker: [Errno 32] Broken pipe

On systems with glibc newer than 2.36 builds will fail when either:

- libfakeroot had been built against glibc later than 2.36
- host system glibc is later than 2.36

Yocto uninative package can be updated for glibc-2.40 by cherry-picking a few commits from yocto kirkstone branch into NXPs BSP:

    pushd sources/poky
    git cherry-pick 2890968bbce028efc47a19213f4eff2ccaf7b979
    git cherry-pick bba090696873805e44b1f7b3278ef8369763a176
    git cherry-pick aab6fc20de9473d8d7f277332601cbae70c53320
    git cherry-pick 43b94d2b8496eae6e512c6deb291b5908b7ada47
    git cherry-pick b8fded3df36ab206eaf3bc25b75acda2544679c5
    git cherry-pick b4b545cd9d3905253c398a6a42a9bc13c42073be
    git cherry-pick ad9420b072896b6a58a571c8123bcb17a813a1e7
    git cherry-pick 529c7c30e6a1b7e1e8a5ba5ba70b8f2f2af770ec
    git cherry-pick b36affbe96b2f9063f75e11f64f5a8ead1cb5c55
    git cherry-pick 8190d9c754c9c3a1962123e1e86d99de96c1224c
    popd

Cache must also be cleared before the next build can succeed:

    cd <build-directory>
    rm -rf tmp sstate-cache cache

## Maintainer Notes

### Patching Linux / U-Boot / ATF / etc.:

Development is done in the respective Reference BSPs (see references) first, they serve as the reference BSP for HW validation.

Patches should be copied without changes to this layer, organised by numeric prefix between the different platforms:

- i.MX8M Plus serves as a common base, starting at `0001-<subject`.
- SolidSense N8 (i.M8M Nano) starts at `0101`.
- i.MX8X Lite starts at `0201`.

## References

- [SolidRun Reference BSP for i.MX8X Lite SoM](https://github.com/SolidRun/imx8dxl_build)
- [SolidRun Reference BSP for i.MX8M Plus SoM](https://github.com/SolidRun/imx8mp_build)
- [SolidRun Reference BSP for SolidSense N8](https://github.com/SolidRun/imx8mp_build/tree/imx8mn)
