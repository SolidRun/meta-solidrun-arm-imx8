FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-change-dependency-from-gitlab-eigen-to-github-eigen-.patch"

# onnxruntime passes armv8.2 specific flags to gcc, causing build errors
# if mcpu was set to any armv8.0 or armv8.1 cpu:
# https://github.com/microsoft/onnxruntime/issues/23152
# as a workaround disable cpu-specific tuning for affected solidrun platforms
TUNE_CCARGS:remove = "-mcpu=cortex-a53+crc+crypto+fp16"
