#!script

loadhost2=; test "$loadhost" = "" || loadhost2="$loadhost:"

BOARD=

test "$fdtfile" = "amlogic/meson-g12b-a311d-khadas-vim3.dtb"   && BOARD=VIM3
test "$fdtfile" = "amlogic/meson-sm1-khadas-vim3l.dtb"         && BOARD=VIM3L
test "$fdtfile" = "amlogic/meson-gxm-khadas-vim2.dtb"          && BOARD=VIM2
test "$fdtfile" = "amlogic/meson-gxl-s905x-khadas-vim.dtb"     && BOARD=VIM1
test "$fdtfile" = "amlogic/meson-gxl-s905x-khadas-vim.dtb"     && BOARD=VIM1
test "$fdtfile" = "rockchip/rk3399-khadas-edge-captain.dtb"    && BOARD=EDGEc
test "$fdtfile" = "rockchip/rk3399-khadas-edge-v.dtb"          && BOARD=EDGEv

echo "====================================="
echo "TFTP_DHCP_TEST $LOADHOST => $loadhost"
echo "====================================="
echo "$fdtfile"
echo "====================================="
echo "BOARD: $BOARD"
echo "====================================="

UBOOT=u-boot.itb
UBOOT_LOADER=idbloader.img

echo "uboot test UPDATE by write to sd <= $UBOOT"

setenv LOADADDR 0x40000000

#mmc dev 1 # sd
mmc dev 0 # mmc

if dhcp $LOADADDR $loadhost2$UBOOT ; then

 echo "SD UPDATE"
 echo CHECK $UBOOT $filesize
 md5sum $LOADADDR $filesize
 #                        16384 2048
 echo mmc write $LOADADDR 4000 800
 mmc write $LOADADDR 4000 800

fi

echo "uboot test UPDATE by write to sd <= $UBOOT_LOADER"

if dhcp $LOADADDR $loadhost2$UBOOT_LOADER ; then

 echo "SD UPDATE"
 echo CHECK $UBOOT_LOADER $filesize
 md5sum $LOADADDR $filesize
 #                        16384 2048
 echo mmc write $LOADADDR 40 200
 mmc write $LOADADDR 40 200

fi

