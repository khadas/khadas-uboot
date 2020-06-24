# DHCP / TFTP / PXE

## prepare scripts

    # make mkimage_script
    mkimage -C none -A arm -T script -d boot.cmd boot.scr.uimg
    # copy to router with dhcp+tftp service
    scp boot.scr.uimg root@router:/tftp/

## USAGE

    dhcp test  && script
    dhcp test1 && script
    ...
    dhcp your_script_name && script

## usage output log example

+ boot.test.rk_uboot_write_sd.cmd.log # chain load from 2 servers

## tftp mkimage script

```
root@openwrt-vim:/tftp# ls -l1 
-rw-r--r--    1 root     root           735 May 16 06:31 boot.scr.uimg
-rw-r--r--    1 root     root           380 Apr 25 07:30 boot.scr2.uimg
-rw-r--r--    1 root     root           379 Apr 25 07:30 boot.scr3.uimg
lrwxrwxrwx    1 root     root            13 Apr 24 11:44 default -> boot.scr.uimg
-rw-r--r--    1 root     root           107 Apr 24 10:05 pxecfg
drwxr-xr-x    2 root     root          1024 May 11 12:55 pxelinux.cfg
-rw-r--r--    1 root     root         16086 May  6 07:19 splash.bmp
lrwxrwxrwx    1 root     root            13 Apr 24 11:44 test -> boot.scr.uimg
lrwxrwxrwx    1 root     root            14 Apr 25 07:30 test2 -> boot.scr2.uimg
lrwxrwxrwx    1 root     root            14 Apr 25 07:30 test3 -> boot.scr3.uimg
```

## PXE

```
root@openwrt-vim:/tftp# ls -l1 /tftp/pxelinux.cfg/
lrwxrwxrwx    1 root     root             7 May 11 12:54 AC17 -> default
lrwxrwxrwx    1 root     root             7 May 11 12:55 AC170 -> default
lrwxrwxrwx    1 root     root             7 May  5 13:05 AC1700 -> default
lrwxrwxrwx    1 root     root             7 Apr 25 13:03 AC170081 -> default
lrwxrwxrwx    1 root     root             7 Apr 25 13:06 AC170089 -> default
lrwxrwxrwx    1 root     root             7 Apr 24 10:24 AC17009F -> default
lrwxrwxrwx    1 root     root             7 May  5 12:46 AC1700DA -> default
lrwxrwxrwx    1 root     root             7 Apr 25 12:59 AC1700DF -> default
lrwxrwxrwx    1 root     root             7 Apr 25 07:40 AC1700EA -> default
lrwxrwxrwx    1 root     root             7 Apr 25 05:59 AC1700F3 -> default
-rw-r--r--    1 root     root           828 May 11 12:53 default
-rw-r--r--    1 root     root           761 May 11 12:52 krescue
-rw-r--r--    1 root     root           107 Apr 24 10:13 vim3
```