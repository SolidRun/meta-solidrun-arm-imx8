# build fails with ccache enabled:
#
# [203/288] cd /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/git/renderdoc && /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/recipe-sysroot-native/usr/bin/cmake -E make_directory /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/build/bin && "ccache g++" 3rdparty/include-bin/main.cpp -o /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/build/bin/include-bin
# FAILED: bin/include-bin /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/build/bin/include-bin
# cd /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/git/renderdoc && /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/recipe-sysroot-native/usr/bin/cmake -E make_directory /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/build/bin && "ccache g++" 3rdparty/include-bin/main.cpp -o /__w/meta-solidrun-arm-imx8/meta-solidrun-arm-imx8/build/tmp/work/armv8a-mx8mp-poky-linux/renderdoc/1.27/build/bin/include-bin
# /bin/sh: 1: ccache g++: not found
# ninja: build stopped: subcommand failed.
#
CCACHE_DISABLE = "1"
