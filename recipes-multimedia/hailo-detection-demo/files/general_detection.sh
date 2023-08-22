#!/bin/bash

: ${HAILO_VIDEO_CAPTURE_DEV:=/dev/video2}

gst-launch-1.0 v4l2src device=${HAILO_VIDEO_CAPTURE_DEV} ! \
    video/x-raw,format=YUY2,width=1280,height=720,framerate=30/1 ! \
    queue leaky=downstream max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
    videoconvert n-threads=4 ! videoscale n-threads=4 ! \
    queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailonet hef-path=/home/root/apps/demo/resources/yolov5m_wo_spp_60p.hef batch-size=1 ! \
    queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailofilter function-name=yolov5 so-path=/usr/lib/hailo-post-processes/libyolo_hailortpp_post.so config-path=null qos=false ! \
    queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    hailooverlay ! \
    queue leaky=downstream max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
    videoconvert ! \
    fpsdisplaysink video-sink=autovideosink name=hailo_display sync=false text-overlay=false