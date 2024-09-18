# git://anongit.freedesktop.org/gstreamer/common doesn't exist any more

NNSHARK_SRC = "git://github.com/nxp-imx/nnshark.git;protocol=https;name=nnshare"
SRC_URI:append = " \
    git://gitlab.freedesktop.org/gstreamer/common.git;protocol=https;branch=master;name=common;destsuffix=git/common \
"
SRCREV_nnshark = "c815749eac865bfb7175c61ed13093e6837aea6f"
SRCREV_common = "b64f03f6090245624608beb5d2fff335e23a01c0"
