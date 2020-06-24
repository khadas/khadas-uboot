#!script

## hyphop ##

#= tftp 1st level script launcher

# next script hostname or ip
# just comment both strings if u need load from same server
LOADHOST=peace
LOADIP=172.23.10.140

# next plain script filename
startscript=boot.test.cmd
#startscript=boot.test2.cmd
#startscript=boot.test3.cmd

# try resolve
setenv loadhost
echo dns $LOADHOST loadhost
dns $LOADHOST loadhost || setenv loadhost $LOADIP

loadhost2=; test "$loadhost" = "" || loadhost2="$loadhost:"

#setenv LOADADDR 0x20000000
setenv LOADADDR $loadaddr

echo "dhcp $LOADADDR $loadhost2$startscript && script $LOADADDR"
dhcp $LOADADDR $loadhost2$startscript && script $LOADADDR

echo BOOT_DHCP_END

