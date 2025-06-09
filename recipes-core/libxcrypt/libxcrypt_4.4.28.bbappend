FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# fix build error with perl >= 5.38
SRC_URI:append = " \
	file://0001-Make-BuildCommon.pm-compatible-with-latest-perl.patch \
	file://0002-Remove-smartmatch-usage-from-gen-crypt-h.patch \
"
