#!/bin/sh

## hyphop ##

#= make xz

D=$(dirname $0)

. $D/make_

PKG=dtc-1.6.0.tar.gz

echo "[i] make $PKG">&2

../download https://github.com/dgibson/dtc/archive/v1.6.0.tar.gz $PKG  || exit 1

cd $DL

D=${PKG%.tar.*}

[ -d "$D" ] || \
    tar -xf $PKG

cd $D

#export LT_SYS_LIBRARY_PATH=$PRE2/lib
#export LDFLAGS="-L$PRE2/lib -Wl,-rpath=$PRE2/lib"

#make clean

export NO_PYTHON=1
export HOME=$PRE2

make && \
    make install
