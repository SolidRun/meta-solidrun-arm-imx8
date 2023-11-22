#!/bin/bash

: ${HAILO_VIDEO_CAPTURE_DEV:=/dev/video2}
: ${HAILO_VIDEO_CAPTURE_DEV_1:=/dev/video3}

gst-launch-1.0 funnel name=fun ! \
    queue name=net max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailonet hef-path=/home/root/apps/detection/resources/yolov5m_yuv.hef ! \
    queue name=filter leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailofilter so-path=/usr/lib/hailo-post-processes/libyolo_post.so config-path=/home/root/apps/detection/resources/configs/yolov5.json qos=false ! \
    queue name=overlay leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailooverlay ! \
    queue name=sid_q leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    streamiddemux name=sid \
    v4l2src device=${HAILO_VIDEO_CAPTURE_DEV} ! \
    video/x-raw, format=YUY2, width=1280, height=720, framerate=30/1 ! \
    queue name=dec_0 max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    fun.sink_0 sid.src_0 ! \
    queue name=displ_0 leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    waylandsink name=hailo_display0 sync=false window-width=1280 window-height=720 \
    v4l2src device=${HAILO_VIDEO_CAPTURE_DEV_1} ! \
    video/x-raw, format=YUY2, width=1280, height=720, framerate=30/1 ! \
    queue name=dec_1 max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    fun.sink_1 sid.src_1 ! \
    queue name=displ_1 leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    waylandsink name=hailo_display1 sync=false window-width=1280 window-height=720
