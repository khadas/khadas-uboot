cat <<end # krescie image script config template
# krescue image script config

#    __ _____                      
#   / //_/ _ \___ ___ ______ _____ 
#  / ,< / , _/ -_|_-</ __/ // / -_)
# /_/|_/_/|_|\__/___/\__/\_,_/\__/ 
#                                  
# krescue advanced install system  

#
# INFO:  https://github.com/hyphop/khadas-rescue-tools/tree/master/image
#

## header block
image:		$NAME
type:		emmc
format:		kresq
builder:	hyphop
date:		$DATE
link:		http://dl.khadas.com/Firmware
label:		$LABEL
match:		BOARD=VIM3L
match:		BOARD=VIM3
match:		BOARD=VIM2
match:		BOARD=VIM1
match:		BOARD=Edge
vars:		BOARD=VIM1 VIM2 VIM3 VIM3L Edge
duration:	2
desc:		mainline uboot for VIMx and Edge khadas boards.
    just single uboot usefull for boot up system from sd or USB / PCIe or DHCP TFTP

# sub 1
sub:	1
source:	*.sd.bin

## raw data block
block:  -
start:  0
sub:	1
data:   %%BOARD%%.u-boot.sd.bin

##END##
end
