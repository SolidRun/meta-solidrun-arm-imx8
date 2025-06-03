# imx8-isp service requires imx8-media-dev kernel module
RDEPENDS:${PN}:append = " kernel-module-imx8-media-dev"
INSANE_SKIP:${PN}:append = " dev-deps"
