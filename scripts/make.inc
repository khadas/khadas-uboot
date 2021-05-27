#!/bin/sh

#= make sub inc 

case $DEF_CONFIG in
    *rk*)
    KHADAS_BOARD=Edge
    VENDOR=Rockchip
#    OLD=1
    ;;
    *vim2_*)
    KHADAS_BOARD=VIM2
    VENDOR=Amlogic
#   OLD=1
    ;;
    *vim3_*)
    KHADAS_BOARD=VIM3
    VENDOR=Amlogic
#   OLD=1
    ;;
    *vim3l_*)
    KHADAS_BOARD=VIM3L
    VENDOR=Amlogic
#   OLD=1
    ;;
    *vim_*)
    KHADAS_BOARD=VIM1
    VENDOR=Amlogic
#   OLD=1
    ;;
esac

BOARD=$KHADAS_BOARD

