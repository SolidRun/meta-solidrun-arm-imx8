# use solidrun fork
UBOOT_SRC:solidrun-imx8 = "git://github.com/SolidRun/u-boot.git;protocol=https"
SRCBRANCH:solidrun-imx8 = "lf-6.6.52-2.2.0-sr-imx8"
SRCREV:solidrun-imx8 = "01e1031959b96349f3f887a6f6818d4ca60c8dc7"

# deploy extra dtbs for imx-mkimage
do_deploy:append:solidrun-imx8() {
    if [ -n "${UBOOT_CONFIG}" ]
    then
        for config in ${UBOOT_MACHINE}; do
            i=$(expr $i + 1);
            for type in ${UBOOT_CONFIG}; do
                j=$(expr $j + 1);
                if [ $j -eq $i ]
                then
                    for dtb_name in ${UBOOT_EXTRA_DTB_NAMES}; do
                        install -v -m 0644 ${B}/${config}/arch/arm/dts/${dtb_name}  ${DEPLOYDIR}/${BOOT_TOOLS}/${dtb_name}-${type}
                    done
                fi
            done
            unset  j
        done
        unset  i
    fi
}
