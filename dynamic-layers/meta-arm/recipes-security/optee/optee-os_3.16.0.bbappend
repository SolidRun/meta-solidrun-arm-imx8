# i.MX8DXL SolidRun SoM supports optee-os like mx8dxlevk
COMPATIBLE_MACHINE:imx8dxl-sr-som = "${MACHINE}"
OPTEEMACHINE:imx8dxl-sr-som = "imx-mx8dxlevk"

# i.MX8MP SolidRun SoM supports optee-os like imx8mpevk
COMPATIBLE_MACHINE:imx8mpsolidrun = "imx8mpsolidrun"
OPTEEMACHINE:imx8mpsolidrun = "imx-mx8mpevk"

# i.MX8 SolidRun Boards support RPMB on eMMC
# - imx8dxl som emmc is mmc0
# - imx8mp som emmc is mmc2
# - rpmb-fs access require avb TA
EXTRA_OEMAKE:append:imx8dxl-sr-som = " CFG_RPMB_FS=y CFG_RPMB_FS_DEV_ID=0 IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 "
EXTRA_OEMAKE:append:imx8mpsolidrun = " CFG_RPMB_FS=y CFG_RPMB_FS_DEV_ID=2 IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 "
