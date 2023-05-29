FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PATCHTOOL = "git"
SRC_URI += " \
        file://0001-Add-imx8mp-solidrun-support-for-lf_v2022.04.patch \
        file://0002-imx8mp-add-memory-support-for-2GByte-Samsung.patch \
        file://0003-imx8mp_solidrun-add-ddr-calibration-for-Samsung-4GB-.patch \
        file://0004-cmd-tlv_eeprom-remove-use-of-global-variable-current.patch \
        file://0005-cmd-tlv_eeprom-remove-use-of-global-variable-has_bee.patch \
	file://0006-cmd-tlv_eeprom-do_tlv_eeprom-stop-using-non-api-read.patch \
	file://0007-cmd-tlv_eeprom-convert-functions-used-by-command-to-.patch \
	file://0008-cmd-tlv_eeprom-remove-empty-function-implementations.patch \
	file://0009-cmd-tlv_eeprom-move-missing-declarations-and-defines.patch \
	file://0010-cmd-tlv_eeprom-hide-access-to-static-tlv_devices-arr.patch \
	file://0011-cmd-tlv_eeprom-clean-up-two-defines-for-one-thing.patch \
	file://0012-cmd-tlv_eeprom-add-my-copyright.patch \
	file://0013-cmd-tlv_eeprom-split-off-tlv-library-from-command.patch \
	file://0014-arm-mvebu-clearfog-enable-tlv-library-for-spl-in-fav.patch \
	file://0015-lib-tlv_eeprom-add-function-for-reading-one-entry-in.patch \
	file://0016-imx8mp-detect-board-from-tlv-eeprom.patch \
	file://0017-imx8mp-don-t-pre-define-fdtfile-environment-variable.patch \
	file://0018-imx8mp-move-mac-address-selection-logic-to-board-fil.patch \
	file://0019-imx8mp-read-mac-from-tlv-eeprom.patch \
	file://0020-imx8mp-implement-tlv-eeprom-vendor-extension-for-kit.patch \
	file://0021-solidrun-imx8mp-unify-TLV-parsing-and-storage.patch \
"

LTO:class-target = ""
