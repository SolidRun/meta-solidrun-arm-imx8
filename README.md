# Yocto BSP Layer for SolidRun i.MX8 based Products

This is a yocto meta layer for adding SolidRun i.MX8 based products support to NXP Yocto SDK.

## HW Compatibility

- [SolidSense N8 Compact](https://www.solid-run.com/edge-gateway-solidsense/#iot-compact)

## Compile base image

### Build Dependencies

Install the `repo` command according to NXP's [i.MX Repo Manifest README](https://github.com/nxp-imx/imx-manifest/blob/db1867b81676a2513b91267e4c85369dee20a800/README.md#install-the-repo-utility), as well as the "Build Host Packages" per [Yocto Documentation](https://docs.yoctoproject.org/5.0.3/brief-yoctoprojectqs/index.html#build-host-packages).

### Download Yocto Recipes

Start in a new empty directory with plenty of free disk space - at least 100GB. Then download the build recipes:

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

### Setup Build Directory

```
[MACHINE=<machine>] [DISTRO=fsl-imx-<backend>] source ./imx-setup-release.sh -b bld-<backend>

<machine>   defaults to `imx6qsabresd`
<backend>   Graphics backend type
    xwayland    Wayland with X11 support - default distro
    wayland     Wayland
    fb          Framebuffer (not supported for mx8)

MACHINE=solidsense-n8 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b build
```

Add to `conf/bblayers.conf`:

```
BBLAYERS += "${BSPDIR}/sources/meta-solidrun-arm-imx8"
```

Re-enter: `. ./setup-environment build`

### Build

```
bitbake imx-image-core
```


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
