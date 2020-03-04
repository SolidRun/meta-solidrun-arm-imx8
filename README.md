OpenEmbedded/Yocto BSP layer for SolidRun's iMX8mm based platforms
================================================================

This layer provides support for SolidRun's iMX8mm based platforms for
use with OpenEmbedded and Yocto Freescale's BSP layer.


# Instructions
1. Create working folder for sources and build files:

		$ mkdir imx-yocto
		$ cd imx-yocto
		$ ROOTDIR=$(pwd)

2. Get NXP Ycoto sources(require repo app):

		$ repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-warrior -m imx-4.19.35-1.1.0.xml
		$ repo sync
		
3. Add meta-solidrun to sources and configurations by cloning the current branch into sources directory

		#Add meta-solidrun to sources and configurations
		$ cd $(ROOTDIR)/sources & git clone ${curr-git} -b ${curr-branch}

4. Configure imx8mmsolidrun board, Distro for xwayland support and create the build environment:
**After running the following commands, you need to accept the EULA(scrool down and run "y")**

		$ cd $(ROOTDIR)
		$ DISTRO=fsl-imx-xwayland MACHINE=imx8mmsolidrun source fsl-setup-release.sh -b build-imx8mm-solidrun
		
5. Appned the following line into $(ROOTDIR)/build-imx8mm-solidrun/conf/bblayers.conf

		BBLAYERS += "${BSPDIR}/sources/meta-solidrun-arm-imx8"

6. The following action will add support for several packages required by Gyfalcon SDK/Demo and othe helpfull packages.
   Append the following lines into $(ROOTDIR)/build-imx8mm-solidrun/conf/local.conf:
		
<pre> 
IMAGE_INSTALL_append = " \
	cmake   \
	pciutils        \
	packagegroup-core-buildessential        \
	libgomp-dev     \
	libgomp \
	libgomp-staticdev \
	libopencv-core-dev      \
	libopencv-ml-dev        \
	libopencv-objdetect-dev \
	libopencv-imgproc-dev   \
	libopencv-highgui-dev   \
	libgcc  \
	pkgconfig       \
	gstreamer1.0-dev        \
	gstreamer1.0-plugins-base-dev   \
	gstreamer1.0-plugins-good-dev   \
	gstreamer1.0-plugins-bad-dev    \
	gtk+-dev        \
	kernel-dev      \
	kernel-modules  \
	kernel-devsrc   \
	xterm           \
"
#python libs:
IMAGE_INSTALL_append = " \
	python-numpy    \
	python-protobuf \
"
TOOLCHAIN_TARGET_TASK_append = " kernel-devsrc"
</pre>
7. Build Yocto image for imx8mm solidrun (**The following command can take several hours**)

		#In ${ROOTDIR}/build-imx8mm-solidrun run:
		$ bitbake imx-image-multimedia
	
8. The image will be ready at ${ROOTDIR}/build-imx8mm-solidrun/tmp/deploy/images/imx8mmsolidrun.


