###############################################################
# BEGIN: Changes to imx-atf_2.6.bb

FILESEXTRAPATHS:prepend:solidsensen8 := "${THISDIR}/${PN}-2.6:"

SRC_URI:append:solidsensen8 = " \
file://0001-changed-the-RDC-for-imx8mn-uart4.patch \
"
