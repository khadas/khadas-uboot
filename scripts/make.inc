#!/bin/sh

#= make sub inc 

case $DEF_CONFIG in
    *rk*)
    KHADAS_BOARD=Edge
    VENDOR=Rockchip
    ;;
    *vim2_*)
    KHADAS_BOARD=VIM2
    VENDOR=Amlogic
    ;;
    *vim3_*)
    KHADAS_BOARD=VIM3
    VENDOR=Amlogic
    ;;
    *vim3l_*)
    KHADAS_BOARD=VIM3L
    VENDOR=Amlogic
    ;;
    *vim_*)
    KHADAS_BOARD=VIM1
    VENDOR=Amlogic
    ;;
esac

BOARD=$KHADAS_BOARD

