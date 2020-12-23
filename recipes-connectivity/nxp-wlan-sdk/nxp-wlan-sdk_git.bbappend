EXTRA_OEMAKE += 'KERNELDIR="${STAGING_KERNEL_DIR}" PREFIX="${D}"'

inherit module

do_compile () {
    # Change build folder to SDK folder
    cd ${S}/mxm_wifiex/wlan_src

    oe_runmake build
}
