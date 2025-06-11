# Yocto BSP Layer for SolidRun i.MX8 based Products

This is a yocto meta layer for adding SolidRun i.MX8 based products support to NXP Yocto SDK.

## HW Compatibility

- [SolidSense N8 Compact](https://www.solid-run.com/edge-gateway-solidsense/#iot-compact)
- [i.MX8M Mini SoM](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/imx8m-mini-som/)

  - [HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#ripple)

- [i.MX8M Plus SoM](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/imx8m-plus-som/)

  - [i.MX8 CuBox-M](https://www.solid-run.com/industrial-computers/cubox/)
  - [i.MX8 HummingBoard Mate](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#mate)
  - [i.MX8 HummingBoard Pro](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#pro)
  - [i.MX8 HummingBoard Pulse](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#pulse)
  - [i.MX8 HummingBoard Ripple](https://www.solid-run.com/embedded-industrial-iot/nxp-i-mx8-family/hummingboard-m/#ripple)

## Binaries

Binaries are generated automatically by our CI infrastructure to [images.solid-run.com](https://images.solid-run.com/IMX8/meta-solidrun-arm-imx8/)

## Build Instructions

### Host Dependencies

Install the `repo` command according to NXP's [i.MX Repo Manifest README](https://github.com/nxp-imx/imx-manifest/blob/db1867b81676a2513b91267e4c85369dee20a800/README.md#install-the-repo-utility), as well as the "Build Host Packages" per [Yocto Documentation](https://docs.yoctoproject.org/5.0.3/brief-yoctoprojectqs/index.html#build-host-packages).

### Download Yocto Recipes

Start in a new empty directory with plenty of free disk space - at least 150GB. Then download the build recipes:

```
repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-scarthgap -m imx-6.6.52-2.2.0.xml

mkdir .repo/local_manifests
cat > .repo/local_manifests/solidrun.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
<!-- add solidrun meta -->
<remote name="solidrun" fetch="https://github.com/SolidRun"/>
<project name="meta-solidrun-arm-imx8" remote="solidrun" path="sources/meta-solidrun-arm-imx8" revision="scarthgap-imx8m"/>

<!-- fetch poky from github mirror -->
<remote name="yp-mirror" fetch="https://github.com/yoctoproject"/>
<project name="poky" remote="yp-mirror"/>
</manifest>
EOF

repo sync
```

### Supported Machines

- `imx8mm-sr-som`: i.MX8M Mini SoM on HummingBoard Ripple
- `imx8mp-sr-som`: i.MX8M Plus SoM on HummingBoard Pro/Pulse/Ripple/Mate and CuBox-M
- `solidsense-n8`: SolidSense N8 Compact

The instructions below use `solidsense-n8` as an example, substitute as needed.

### Setup Build Directory

Initialise a new build directory using NXP's `imx-setup-release.sh` script:

    MACHINE=solidsense-n8 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b build

Then add to `conf/bblayers.conf` the SolidRun meta layer:

    BBLAYERS += "${BSPDIR}/sources/meta-solidrun-arm-imx8"

When returning to the build directory at a later time the command below should be used instead:

    . ./setup-environment build

### Build

With the build directory set up, any desirable yocto target may be built, e.g. the nxp `imx-image-core`:

    bitbake imx-image-core

Build results will be produced in the `tmp/deploy/images/solidsense-n8` subdirectory.

## Common Issues

### make version 4.2.1 is known to have issues

```
ERROR:  OE-core's config sanity checker detected a potential misconfiguration.
    Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
    Following is the list of potential problems / advisories:

    make version 4.2.1 is known to have issues on Centos/OpenSUSE and other non-Ubuntu systems. Please use a buildtools-make-tarball or a newer version of make.
```

Prebuilt buildtools with compatible versions are available for download from the yocto project: [x86_64-buildtools-extended-nativesdk-standalone-5.0.3.sh](https://downloads.yoctoproject.org/releases/yocto/yocto-5.0.3/buildtools/x86_64-buildtools-extended-nativesdk-standalone-5.0.3.sh)
Follow the Yocto Instructions on [Downloading a Pre-Built buildtools Tarball](https://www.rpsys.net/yocto-docs/ref-manual/ref-system-requirements.html#downloading-a-pre-built-buildtools-tarball).

### shared-mime-info-native fails to build

Build of `shared-mime-info-native` recipe can fail with the error below:

```
| ../git/src/update-mime-database.cpp:25:10: fatal error: filesystem: No such file or directory
|  #include <filesystem>
|           ^~~~~~~~~~~~
| compilation terminated.
| [80/85] gcc  -o src/test-subclassing src/test-subclassing.p/test-subclassing.c.o -L/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib -L/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/lib -Wl,--as-needed -Wl,--no-undefined -Wl,--enable-new-dtags -Wl,-rpath-link,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib -Wl,-rpath-link,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/lib -Wl,-rpath,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib -Wl,-rpath,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/lib -Wl,-O1 -Wl,--allow-shlib-undefined -Wl,--start-group -Wl,--dynamic-linker=/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/sysroots-uninative/x86_64-linux/lib/ld-linux-x86-64.so.2 -pthread -Wl,-rpath,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/lib -Wl,-rpath-link,/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/lib /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/lib/libglib-2.0.so /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/lib/libxml2.so -Wl,--end-group
| [81/85] gcc -Isrc/tree-magic.p -Isrc -I../git/src -I/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/include/glib-2.0 -I/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/lib/glib-2.0/include -I/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/include -I/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/include/libmount -I/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/lib/pkgconfig/../../../usr/include/blkid -fdiagnostics-color=always -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -isystem/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/include -O2 -pipe -pthread -MD -MQ src/tree-magic.p/test-tree-magic.c.o -MF src/tree-magic.p/test-tree-magic.c.o.d -o src/tree-magic.p/test-tree-magic.c.o -c ../git/src/test-tree-magic.c
| [82/85] /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/bin/xmlto -o data/shared-mime-info-spec-html html-nochunks ../git/data/shared-mime-info-spec.xml
| [83/85] /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/bin/meson.real --internal msgfmthelper --msgfmt=/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/bin/msgfmt --datadirs=/opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/git/data/. ../git/data/freedesktop.org.xml.in data/freedesktop.org.xml xml ../git/data/../po
| ninja: build stopped: subcommand failed.
| INFO: autodetecting backend as ninja
| INFO: calculating backend command to run: /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/recipe-sysroot-native/usr/bin/ninja -j 32 -v
| WARNING: /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/temp/run.do_compile.10443:155 exit 1 from 'meson compile -v -j 32'
| WARNING: Backtrace (BB generated script):
|       #1: meson_do_compile, /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/temp/run.do_compile.10443, line 155
|       #2: do_compile, /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/temp/run.do_compile.10443, line 150
|       #3: main, /opt/workspace/YOCTO/imx8-scarthgap/build/tmp/work/x86_64-linux/shared-mime-info-native/2.4/temp/run.do_compile.10443, line 159
ERROR: Task (virtual:native:/opt/workspace/YOCTO/imx8-scarthgap/sources/poky/meta/recipes-support/shared-mime-info/shared-mime-info_2.4.bb:do_compile) failed with exit code '1'
```

As a workaround ensure that the host OS does not have boost development files installed, then clean state of bitbake and build `shared-mime-info-native` first before any other target:

```
rm -rf tmp sstate-cache
bitbake shared-mime-info-native
```

### permission error in disable_network

Bitbake can fail with a confusing permission error while trying to disable it's child processes network access:

```
ERROR: PermissionError: [Errno 1] Operation not permitted

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/workspace/YOCTO/imx8-scarthgap/sources/poky/bitbake/bin/bitbake-worker", line 278, in child
    bb.utils.disable_network(uid, gid)
  File "/opt/workspace/YOCTO/imx8-scarthgap/sources/poky/bitbake/lib/bb/utils.py", line 1696, in disable_network
    with open("/proc/self/uid_map", "w") as f:
PermissionError: [Errno 1] Operation not permitted

ERROR: Task (virtual:native:/opt/workspace/YOCTO/imx8-scarthgap/sources/poky/meta/recipes-devtools/autoconf/autoconf_2.72e.bb:do_unpack) failed with exit code '1'
```

See [Ubuntu Bug 2056555](https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/2056555) for more details.

As a workaround apparmor "unprivileged_userns" profile can be temporarily disabled:

    sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns


## Maintainer Notes

### Patching Linux / U-Boot / ATF / etc.:

Development is done in [imx8mp_build: branch "develop-lf-6.6.52-2.2.0-imx8mn"](https://github.com/SolidRun/imx8mp_build/tree/develop-lf-6.6.52-2.2.0-imx8mn) first, it serves as the reference BSP for HW validation.
Patches should be copied without changes from imx8mp_build to this layer.

For separation between different products patches, number their patches at different offsets:

- 0001: i.MX8M Nano SolidSense N8 Patches
- 0101: i.MX8M Mini Patches
