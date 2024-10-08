# disable rpmb emulation as machine supports real rpmb
EXTRA_OEMAKE:append:imx8dxl-sr-som = " RPMB_EMU=0 "
