#!script

echo "====================================="
echo "TFTP_DHCP_TEST $LOADHOST => $loadhost"
echo "====================================="

UBOOT=u-boot.spi.bin.gz

OFF=0

echo "SPI UPDATE $UBOOT"

spidata=0x02000000

if dhcp $loadhost:$UBOOT ; then

 echo CHECK_SPI_UBOOT $UBOOT $filesize

 md5sum $loadaddr $filesize

 if unzip $loadaddr $spidata; then

 echo REWRITE_SPI_UBOOT $UBOOT $filesize
 sf probe
 md5sum $spidata $filesize

 echo "SPI ERASE PLZ WAIT"
# sf erase 0 +$filesize
 echo "SPI UPDATE $filesize"
 sf update $spidata $OFF $filesize
 echo "DONE"
 sf read $loadaddr $OFF $filesize
 md5sum $loadaddr $filesize

 fi

fi
