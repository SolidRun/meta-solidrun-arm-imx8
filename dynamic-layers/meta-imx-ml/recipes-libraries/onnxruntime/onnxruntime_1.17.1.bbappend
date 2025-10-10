FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# onnxruntime passes armv8.2 specific flags to gcc, causing build errors
# if mcpu was set to any armv8.0 or armv8.1 cpu:
# https://github.com/microsoft/onnxruntime/issues/23152
# as a workaround disable cpu-specific tuning for affected solidrun platforms
TUNE_CCARGS:remove = "-mcpu=cortex-a53+crc+crypto+fp16"
