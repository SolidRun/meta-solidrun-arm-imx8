OpenEmbedded/Yocto BSP layer for SolidRun's iMX8MPlus based platforms
================================================================

This layer provides support for SolidRun's iMX8mp based platforms for
use with OpenEmbedded and Yocto Freescale's BSP layer.


# Instructions
1. Create working folder for sources and build files:

		$ mkdir imx-yocto
		$ cd imx-yocto

2. Get NXP Ycoto sources(require repo app):

		$ repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-zeus -m imx-5.4.47-2.2.0.xml
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

5. Appned the following line into conf/bblayers.conf

		BBLAYERS += "${BSPDIR}/sources/meta-solidrun-arm-imx8"

6. Build Yocto image for imx8mp solidrun, by running the first, which is a minimal image (lacks firmwares) and then second which is full image including demos:
(**The following command can take several hours**)

    $ bitbake core-image-minimal
		$ bitbake imx-image-multimedia

The image will be ready at tmp/deploy/images/imx8mpsolidrun and should look as follow:

		tmp/deploy/images/imx8mpsolidrun/core-image-minimal-imx8mpsolidrun.wic.bz2

or

    tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.bz2

To flash the image to a micro SD run -

	bunzip2 -c tmp/deploy/images/imx8mpsolidrun/imx-image-full-imx8mpsolidrun.wic.bz2 | sudo dd of=/dev/sdX bs=1M

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
