# Copyright 2025 Josua Mayer <josua@solid-run.com>
# Released under the MIT license (see COPYING.MIT for the terms)

require dynamic-layers/qt6-layer/recipes-fsl/images/imx-image-full-dev.bb

IMAGE_INSTALL:append = " \
	chromium-ozone-wayland \
	git \
	kernel-modules \
	pavucontrol \
"

# remove imx-voice-player as it breaks pipewire by preinstalling file /etc/pipewire/pipewire.conf.d/imx-multimedia-sink.conf
IMAGE_INSTALL:remove = "imx-voice-player"

# install extra application launchers
ROOTFS_POSTPROCESS_COMMAND:append = "install_sr_launchers; "

install_sr_launchers() {
	# Terminal Emulator
	icon=${datadir}/weston/terminal.png
	app="/usr/bin/weston-terminal"
	printf "\n[launcher]\nicon=${icon}\npath=${app}\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini

	# Web Browser
	icon=${datadir}/icons/hicolor/24x24/apps/chromium.png
	app="/usr/bin/chromium --no-sandbox"
	printf "\n[launcher]\nicon=${icon}\npath=${app}\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini

	# NXP "GoPoint" Demo Collection
	icon=${GPNT_APPS_FOLDER}/icon/icon_demo_launcher.png
	app="/usr/bin/gopoint"
	printf "\n[launcher]\nicon=${icon}\npath=${app}\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini

	# Audio Volume Control
	icon=${datadir}/icons/hicolor/24x24/apps/pavucontrol.png
	rsvg-convert ${IMAGE_ROOTFS}${datadir}/icons/Adwaita/symbolic/legacy/multimedia-volume-control-symbolic.svg -h 24 -w 24 -f png -o ${IMAGE_ROOTFS}${icon}
	app="/usr/bin/pavucontrol"
	printf "\n[launcher]\nicon=${icon}\npath=${app}\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
}
