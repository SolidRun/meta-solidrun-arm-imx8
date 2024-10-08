#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause

GPIO_RESETN="5d090000.gpio 11"
GPIO_PWRKEY="5d090000.gpio 12"

gpioget ${GPIO_RESETN}
gpioget ${GPIO_PWRKEY}

# Initial Settings:
# - disable vbat
# - assert reset
# - deassert power key
echo disabled > /sys/devices/platform/userspace-consumer-lte-vbat/state
gpioset ${GPIO_RESETN}=0
gpioset ${GPIO_PWRKEY}=1

sleep 1

# Power-On Sequence:
# - enable vbat
# - deassert reset
# - toggle power key
echo enabled > /sys/devices/platform/userspace-consumer-lte-vbat/state
gpioset ${GPIO_RESETN}=1
sleep 0.03
gpioset ${GPIO_PWRKEY}=0
sleep 0.5
gpioset ${GPIO_PWRKEY}=1
