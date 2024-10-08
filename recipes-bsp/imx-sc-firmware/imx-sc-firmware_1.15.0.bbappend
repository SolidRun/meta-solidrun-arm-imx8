# SolidRun i.MX8DXL SoM has custom SCU Firmware
SRC_URI:append = " https://images.solid-run.com/IMX8/imx8dxl_build/20240903-b90506c/mx8dxl-sr-som-scfw-tcm.bin;name=sr-som"
SRC_URI[sr-som.sha256sum] = "20fceee37d3eb53959b280a73dc87c31469de6c10db0bdc1db8a39c40a79a1d5"

BOARD_TYPE:imx8dxl-sr-som = "sr-som"

# copy custom scu firmware where do_deploy expects it
do_deploy:prepend() {
	cp ${WORKDIR}/mx8dxl-sr-som-scfw-tcm.bin ${S}/
}
