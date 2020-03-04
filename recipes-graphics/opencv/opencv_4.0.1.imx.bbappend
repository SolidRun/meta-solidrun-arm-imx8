FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE_append = "\
    -DWITH_GTK=ON       \
    -DWITH_GTK_2_X=OFF  \
    -DWITH_GTK3=ON      \
    -DWITH_QT=OFF       \
    -DWITH_GSTREAMER=ON \
"
PACKAGECONFIG_GTK = "gtk"
PACKAGECONFIG_GTK_mx8 = "gtk"
