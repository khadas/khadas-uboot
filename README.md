# Khadas u-boot [![Build Status](https://github.com/khadas/khadas-uboot/workflows/Build/badge.svg)](https://github.com/khadas/khadas-uboot/actions)


<!--
# Khadas u-boot [![Build Status](https://travis-ci.org/krescue/khadas-uboot.svg?branch=master)](https://travis-ci.org/krescue/khadas-uboot)
-->

mainline u-boot for Khadas VIM and EDGE sbc series

## Features

+ universal series for VIM1 VIM2 VIM3 VIM3L EDGE boards
+ mainline u-boot + patches
+ suitable for SPI - SD - MMC
+ spi flash - read / write / bootup
+ usb kbd
+ usb storages
+ HDMI output
+ HDMI 4K supported
+ EFI
+ embed LOGO splash - easy customize
+ extra commands like `script` `kbi`
+ boot seq SPI => USB => SD => NVME => MMC => PXE => DHCP
+ fully stand-alone
+ auto store uboot env to first fat partition uboot.env file to booted source

## install & usage

```
git clone https://github.com/krescue/khadas-uboot
cd khadas-uboot
./scripts/prepare
./scripts/make

```
or

```
scripts/make [ARGS]

scripts/make re     # remove builded source = prepare for full rebuild
scripts/make clean  # clean

```

## make all

generate all images for all boards

```
./scripts/prepare
./scripts/make_all

```

VIMx status
=============

+ all problem fixed

EDGE status
=============

+ hdmi FULLHD ok
+ hdmi 4K fixed
+ splash logo
+ spi flash
+ SPL boot (TPL removed)
+ boot from SPI + MMC + SD
+ compact size - uboot single files for SD and SPI
+ ATF bl31
+ usb keyboard
+ network
+ usb partialy WORKS
+ in testing stage
+ NVME in progress

## scripts

+ [scripts](scripts)

## Downloads

## README

## spi usage 

## related projects

+ https://github.com/krescue/krescue
+ https://github.com/krescue/khadas-rescue-sdk
+ https://github.com/krescue/khadas-rescue-rootfs
+ https://github.com/krescue/khadas-openwrt-feed-extra
+ https://github.com/krescue/khadas-openwrt-sdk
+ https://github.com/krescue/khadas-linux-kernel
+ https://github.com/krescue/khadas-uboot

\## hyphop ##
