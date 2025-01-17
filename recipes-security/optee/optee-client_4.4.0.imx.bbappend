# SolidSense N8 supports rpmb, disable emulation
EXTRA_OECMAKE:append:solidsense-n8 = " -DRPMB_EMU=0 "
