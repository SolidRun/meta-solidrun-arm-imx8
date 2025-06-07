#
# Copied from meta-freescale/recipes-bsp/imx-mkimage/imx-boot_1.0.bb,
# keep in sync on bsp upgrades.
#
# Adapted to allow including extra dtbs via UBOOT_EXTRA_DTB_NAMES variable in boot image:
#
#--- a/recipes-bsp/imx-mkimage/imx-boot_1.0.bb
#+++ b/recipes-bsp/imx-mkimage/imx-boot_1.0.bb
#@@ -221,13 +221,17 @@ do_compile() {
#                 UBOOT_NAME_EXTRA="u-boot-${MACHINE}.bin-${UBOOT_CONFIG_EXTRA}"
#                 BOOT_CONFIG_MACHINE_EXTRA="imx-boot-${MACHINE}-${UBOOT_CONFIG_EXTRA}.bin"
#
#+                for dtb_name in ${UBOOT_EXTRA_DTB_NAMES}; do
#+                    ln -sf ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${dtb_name}-${type} ${BOOT_STAGING}/${dtb_name}
#+                done
#+
#                 for target in ${IMXBOOT_TARGETS}; do
#                     compile_${SOC_FAMILY}
#                     case $target in
#                     *no_v2x)
#                         # Special target build for i.MX 8DXL with V2X off
#                         bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
#-                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO dtbs=${UBOOT_DTB_NAME_EXTRA} flash_linux_m4
#+                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO dtbs=${UBOOT_DTB_NAME_EXTRA} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" flash_linux_m4
#                         ;;
#                     *stmm_capsule)
#                         # target for flash_evk_stmm_capsule or
#@@ -235,11 +239,11 @@ do_compile() {
#                         cp ${RECIPE_SYSROOT_NATIVE}/${bindir}/mkeficapsule ${BOOT_STAGING}
#                         bbnote "building ${IMX_BOOT_SOC_TARGET} - TEE=tee.bin-stmm ${target}"
#                         cp ${DEPLOY_DIR_IMAGE}/CRT.* ${BOOT_STAGING}
#-                        make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm dtbs=${UBOOT_DTB_NAME} ${REV_OPTION} ${target}
#+                        make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm dtbs=${UBOOT_DTB_NAME} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" ${REV_OPTION} ${target}
#                         ;;
#                     *)
#                         bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} ${MKIMAGE_EXTRA_ARGS} ${target}"
#-                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} ${MKIMAGE_EXTRA_ARGS} dtbs=${UBOOT_DTB_NAME} ${target}
#+                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} ${MKIMAGE_EXTRA_ARGS} dtbs=${UBOOT_DTB_NAME} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" ${target}
#                         ;;
#                     esac
#
do_compile:mx8m-generic-bsp() {
    # mkimage for i.MX8
    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}
        if ${DEPLOY_OPTEE_STMM}; then
            # Copy tee.bin to tee.bin-stmm
            cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}/tee.bin-stmm
        fi
    fi
    # Copy OEI firmware to SoC target folder to mkimage
    if [ "${OEI_ENABLE}" = "YES" ]; then
        cp ${DEPLOY_DIR_IMAGE}/${OEI_NAME} ${BOOT_STAGING}
    fi

    for type in ${UBOOT_CONFIG}; do
        if [ "${@d.getVarFlags('UBOOT_DTB_NAME')}" = "None" ]; then
            UBOOT_DTB_NAME_FLAGS="${type}:${UBOOT_DTB_NAME}"
        else
            UBOOT_DTB_NAME_FLAGS="${@' '.join(flag + ':' + dtb for flag, dtb in (d.getVarFlags('UBOOT_DTB_NAME')).items()) if d.getVarFlags('UBOOT_DTB_NAME') is not None else '' }"
        fi

        for key_value in ${UBOOT_DTB_NAME_FLAGS}; do
            type_key="${key_value%%:*}"
            dtb_name="${key_value#*:}"

            if [ "$type_key" = "$type" ]
            then
                bbnote "UBOOT_CONFIG = $type, UBOOT_DTB_NAME = $dtb_name"

                UBOOT_CONFIG_EXTRA="$type_key"
                if [ -e ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${dtb_name}-${type} ] ; then
                    UBOOT_DTB_NAME_EXTRA="${dtb_name}-${type}"
                else
                    # backward compatibility
                    UBOOT_DTB_NAME_EXTRA="${dtb_name}"
                fi
                UBOOT_NAME_EXTRA="u-boot-${MACHINE}.bin-${UBOOT_CONFIG_EXTRA}"
                BOOT_CONFIG_MACHINE_EXTRA="imx-boot-${MACHINE}-${UBOOT_CONFIG_EXTRA}.bin"

                for dtb_name in ${UBOOT_EXTRA_DTB_NAMES}; do
                    ln -sf ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${dtb_name}-${type} ${BOOT_STAGING}/${dtb_name}
                done

                for target in ${IMXBOOT_TARGETS}; do
                    compile_${SOC_FAMILY}
                    case $target in
                    *no_v2x)
                        # Special target build for i.MX 8DXL with V2X off
                        bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO dtbs=${UBOOT_DTB_NAME_EXTRA} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" flash_linux_m4
                        ;;
                    *stmm_capsule)
                        # target for flash_evk_stmm_capsule or
                        # flash_singleboot_stmm_capsule
                        cp ${RECIPE_SYSROOT_NATIVE}/${bindir}/mkeficapsule ${BOOT_STAGING}
                        bbnote "building ${IMX_BOOT_SOC_TARGET} - TEE=tee.bin-stmm ${target}"
                        cp ${DEPLOY_DIR_IMAGE}/CRT.* ${BOOT_STAGING}
                        make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm dtbs=${UBOOT_DTB_NAME} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" ${REV_OPTION} ${target}
                        ;;
                    *)
                        bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} ${MKIMAGE_EXTRA_ARGS} ${target}"
                        make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} ${MKIMAGE_EXTRA_ARGS} dtbs=${UBOOT_DTB_NAME} supp_dtbs="${UBOOT_EXTRA_DTB_NAMES}" ${target}
                        ;;
                    esac

                    if [ -e "${BOOT_STAGING}/flash.bin" ]; then
                        cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE_EXTRA}-${target}
                    fi
                done

                unset UBOOT_CONFIG_EXTRA
                unset UBOOT_DTB_NAME_EXTRA
                unset UBOOT_NAME_EXTRA
                unset BOOT_CONFIG_MACHINE_EXTRA
            fi

            unset type_key
            unset dtb_name
        done

        unset UBOOT_DTB_NAME_FLAGS
    done
    unset type
}
