# disable rpmb emulation as machine supports real rpmb
EXTRA_OECMAKE:append:imx8dxl-sr-som = " -DRPMB_EMU=0 "
