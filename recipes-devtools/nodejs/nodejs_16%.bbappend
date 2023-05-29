FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
# SRC_URI += " \
#        file://0001-deps-add-fno-strict-aliasing-flag-to-libuv.patch \
# "

LTO:class-target = ""

# Node is way too cool to use proper autotools, so we install two wrappers to forcefully inject proper arch cflags to workaround gypi
do_configure () {
    export LD="${CXX}"
    GYP_DEFINES="${GYP_DEFINES}" export GYP_DEFINES
    # $TARGET_ARCH settings don't match --dest-cpu settings
    python3 configure.py --prefix=${prefix} --cross-compiling \
               --shared-openssl \
               --without-dtrace \
               --without-etw \
               --dest-cpu="${@map_nodejs_arch(d.getVar('TARGET_ARCH'), d)}" \
               --dest-os=linux \
               --libdir=${D}${libdir} \
               ${@bb.utils.contains("DISTRO_FEATURES", "lto", "--enable-lto", "", d)} \
               ${ARCHFLAGS} \
               ${PACKAGECONFIG_CONFARGS}
}
