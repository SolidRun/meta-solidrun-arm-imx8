EXTRA_OESCONS:remove:aarch64 = " ${SCONS_MAXLINELENGTH}"

do_configure() {
        if [ -n "${CONFIGURESTAMPFILE}" -a "${S}" = "${B}" ]; then
                if [ -e "${CONFIGURESTAMPFILE}" -a "`cat ${CONFIGURESTAMPFILE}`" != "${BB_TASKHASH}" -a "${CLEANBROKEN}" != "1" ]; then
                        ${STAGING_BINDIR_NATIVE}/scons --directory=${S} --clean ${EXTRA_OESCONS}
                fi

                mkdir -p `dirname ${CONFIGURESTAMPFILE}`
                echo ${BB_TASKHASH} > ${CONFIGURESTAMPFILE}
        fi
}
