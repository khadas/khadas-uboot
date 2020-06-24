MAINLINE-UBOOT
==============

one uboot source for krescue / debian / ubuntu / openwrt and any other distros

## Features ( patches )

+ univeral series for VIM1 VIM2 VIM3 VIM3L EDGE boards
+ suitable for SPI - SD - MMC
+ spi flash - read / write / bootup
+ usb kbd + storages
+ HDMI output
+ embed LOGO splash - easy customize
+ extra commands like `script` `kbi`
+ boot seq SPI => USB => SD => NVME => MMC => PXE => DHCP
+ fully stand-alone
+ auto store uboot env to first fat partition uboot.env file to booted source
+ some other small improves ...

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
