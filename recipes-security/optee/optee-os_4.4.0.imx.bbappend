# SolidSense N8 supports RPMB on eMMC
EXTRA_OEMAKE:append:solidsense-n8 = " \
	CFG_RPMB_FS=y \
	CFG_RPMB_FS_DEV_ID=2 \
	IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 \
	CFG_RPMB_WRITE_KEY=n \
"

# i.MX8MM SoM supports RPMB on eMMC
EXTRA_OEMAKE:append:imx8mm-sr-som = " \
	CFG_RPMB_FS=y \
	CFG_RPMB_FS_DEV_ID=2 \
	IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 \
	CFG_RPMB_WRITE_KEY=n \
"

# i.MX8MP SoM supports RPMB on eMMC
EXTRA_OEMAKE:append:imx8mp-sr-som = " \
	CFG_RPMB_FS=y \
	CFG_RPMB_FS_DEV_ID=2 \
	IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067 \
	CFG_RPMB_WRITE_KEY=n \
"
