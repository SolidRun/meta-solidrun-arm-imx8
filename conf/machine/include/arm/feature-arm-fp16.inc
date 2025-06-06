# Double-recision floating-point instructions for:
# armv8-a, armv8.1-a, armv8.2-a

TUNEVALID[fp16] = "Enable double precision floating-point instructions for ARMv8"
TUNE_CCARGS_MARCH_OPTS .= "${@bb.utils.contains('TUNE_FEATURES', 'fp16', '+fp16', '', d)}"
