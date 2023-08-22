#!/bin/bash

gst-launch-1.0 multifilesrc location=/home/root/apps/license_plate_recognition/resources/lpr.raw name=src_0 loop=true ! \
 rawvideoparse format=yuy2 width=1920 height=1080 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailonet hef-path=/home/root/apps/license_plate_recognition/resources/yolov5m_vehicles_no_ddr_yuy2.hef vdevice-key=1 scheduling-algorithm=1 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailofilter so-path=/usr/lib/hailo-post-processes/libyolo_post.so config-path=/home/root/apps/license_plate_recognition/resources/configs/yolov5_vehicle_detection.json function-name=yolov5_vehicles_only qos=false ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailotracker name=hailo_tracker keep-past-metadata=true kalman-dist-thr=.5 iou-thr=.6 keep-tracked-frames=2 keep-lost-frames=2 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 tee name=context_tee context_tee. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 videobox top=1 bottom=1 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailooverlay line-thickness=3 font-thickness=1 qos=false ! \
 hailofilter use-gst-buffer=true so-path=/home/root/apps/license_plate_recognition/resources/liblpr_overlay.so qos=false ! \
 fpsdisplaysink video-sink=autovideosink name=hailo_display sync=true text-overlay=false context_tee. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailocropper so-path=/usr/lib/hailo-post-processes/cropping_algorithms/liblpr_croppers.so function-name=vehicles_without_ocr internal-offset=true drop-uncropped-buffers=true name=cropper1 hailoaggregator name=agg1 cropper1. ! \
 queue leaky=no max-size-buffers=50 max-size-bytes=0 max-size-time=0 ! \
 agg1. cropper1. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailonet hef-path=/home/root/apps/license_plate_recognition/resources/tiny_yolov4_license_plates_yuy2.hef vdevice-key=1 scheduling-algorithm=1 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailofilter so-path=/usr/lib/hailo-post-processes/libyolo_post.so config-path=/home/root/apps/license_plate_recognition/resources/configs/yolov4_licence_plate.json function-name=tiny_yolov4_license_plates qos=false ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 agg1. agg1. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailocropper so-path=/usr/lib/hailo-post-processes/cropping_algorithms/liblpr_croppers.so function-name=license_plate_quality_estimation \
  internal-offset=true drop-uncropped-buffers=true name=cropper2 hailoaggregator name=agg2 cropper2. ! \
 queue leaky=no max-size-buffers=50 max-size-bytes=0 max-size-time=0 ! \
 agg2. cropper2. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailonet hef-path=/home/root/apps/license_plate_recognition/resources/lprnet_yuy2.hef vdevice-key=1 scheduling-algorithm=1 ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailofilter so-path=/usr/lib/hailo-post-processes/libocr_post.so qos=false ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 agg2. agg2. ! \
 queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
 hailofilter use-gst-buffer=true so-path=/home/root/apps/license_plate_recognition/resources/liblpr_ocrsink.so qos=false ! \
 fakesink sync=false async=false
 