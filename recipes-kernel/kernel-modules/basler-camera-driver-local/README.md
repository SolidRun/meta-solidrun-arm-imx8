# Introduction 
This project started to show a demo at embeddedworld 2019. It creates camera sensor drivers for linux.
Sensor drivers are only for testing.

# Which driver are supported
- Camera driver for daA2500-60mc (AR0521 color without ISP; module name: ar0521_camera)
- Camera driver for daA4200-30mci (AR1335 color with ISP AP1320; module name: ap1320_ar0521_camera)
- Camera driver for daA2500-60mci (AR0521 color with ISP AP1320; module name: ap1320_ar0521_camera)

# Which format and solution is supported by the camera sensor driver
- daA2500-60mc: RAW8 2592x1944@30fps CSI2: 4 lanes 530MBit/lane
- daA4200-30mci: YUV422 1920x1080@17fps, 2592x1944@53fps, 4208x3120@21fps CSI2: 4 lanes 1200MBit/lane
- daA2500-60mci: YUV422 1920x1080@80fps, 2600x1952@33fps CSI2: 4 lanes 