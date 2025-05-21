# SolidSense N8 supports rpmb, disable emulation
EXTRA_OECMAKE:append:solidsense-n8 = " -DRPMB_EMU=0 "

# i.MX8MM SoM supports rpmb, disable emulation
EXTRA_OECMAKE:append:imx8mm-sr-som = " -DRPMB_EMU=0 "

# i.MX8MP SoM supports rpmb, disable emulation
EXTRA_OECMAKE:append:imx8mp-sr-som = " -DRPMB_EMU=0 "
