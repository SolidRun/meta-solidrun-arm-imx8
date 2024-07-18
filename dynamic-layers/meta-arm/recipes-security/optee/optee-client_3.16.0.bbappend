# SolidRun SoMs support rpmb, disable emulation
EXTRA_OECMAKE:append:imx8dxl-sr-som = " -DRPMB_EMU=0 "
EXTRA_OECMAKE:append:imx8mpsolidrun = " -DRPMB_EMU=0 "
