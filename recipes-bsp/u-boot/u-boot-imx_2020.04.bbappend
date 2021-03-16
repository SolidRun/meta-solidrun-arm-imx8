FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \       
	file://0001-Add-imx8mn-solidrun-configuration-files-to-u-boot.patch \
	file://0002-imx8mn-Add-imx8mn-solidrun-device-tree-to-the-Makfil.patch \
	file://0003-imx8mn-Add-imx8mn-solidrun-device-tree.patch \
"
