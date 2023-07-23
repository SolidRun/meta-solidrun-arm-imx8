OpenEmbedded/Yocto BSP layer for SolidRun's iMX8MPlus based platforms
================================================================

This layer provides support for SolidRun's iMX8mp based platforms for
use with OpenEmbedded and Yocto Freescale's BSP layer.


# Instructions
1. Create working folder for sources and build files:

		$ mkdir imx-yocto
		$ cd imx-yocto

2. Get NXP Ycoto sources(require repo app):

		$ repo init -u https://github.com/SolidRun/meta-solidrun-arm-imx8 -b kirkstone-imx8m -m sr-imx-5.15.71-2.2.0.xml
		$ repo sync

3. Add the meta-solidrun-arm-imx8 layer (curent git repository) into the sources directory, the directory layout should be like this:
				<pre>
					.
					├── sources
					│   	├── base
					│   	├── meta-browser
					│   	├── meta-freescale
					│   	├── meta-freescale-3rdparty
					│   	├── meta-freescale-distro
					│   	├── meta-fsl-bsp-release
					│   	├── meta-openembedded
					│   	├── meta-qt5
					│   	├── meta-rust
					│   	├── meta-solidrun-arm-imx8
					│   	├── meta-timesys
					│   	└── poky
					│
					├── downloads
					└── ...
				</pre>
4. Configure imx8mpsolidrun board, Distro for xwayland support and create the build environment:
**After running the following commands, you need to accept the EULA (scrool down and run "y")**

		$ DISTRO=fsl-imx-xwayland MACHINE=imx8mpsolidrun source imx-setup-release.sh -b build-xwayland-imx8mpsolidrun

5. Append the following line into conf/bblayers.conf

		BBLAYERS += "${BSPDIR}/sources/meta-solidrun-arm-imx8"

6. Build Yocto image for imx8mp solidrun, by running the first, which is a minimal image (lacks firmwares) and then second which is full image including demos:
(**The following command can take several hours**)

    $ bitbake core-image-minimal
    $ bitbake imx-image-full
	$ bitbake imx-hailo-demo-image

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
    docker build --tag yocto-build-image:latest --no-cache --build-arg USERNAME=<your user name> --build-arg PUID=<your user ID, for example 1000> --build-arg PGID=<your group ID, for example 1000> .

## Spin a container and mount your working directory into it

    docker run --rm -it -v /home/<username>/work/imx8mp/:/home/<username>/work/imx8mp/ yocto-build-image:latest /bin/bash
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
If you prefer to use NetworkManager and ModemManager rather than the default Yocto configuration of connman and ofono please add the following snippet to your local.conf
	
	IMAGE_INSTALL_remove += " ofono connman connman-gnome connman-conf"
	IMAGE_INSTALL_remove += " packagegroup-core-tools-testapps"
	PACKAGE_EXCLUDE += "ofono connman connman-gnome connman-conf"
	PACKAGE_EXCLUDE += "connman-client connman-tools"
	PACKAGE_EXCLUDE += "packagegroup-core-tools-testapps"
	DISTRO_FEATURES_remove = " 3g"
	IMAGE_INSTALL_append = " networkmanager networkmanager-nmcli modemmanager"
	IMAGE_INSTALL_append = " networkmanager-bash-completion"
	PACKAGECONFIG_append_pn-networkmanager = " modemmanager ppp"
