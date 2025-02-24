#!/bin/sh

## hyphop ##

#= make python2

D=$(dirname $0)

CHK="$D"/../../dl/python2

[ -s "$CHK" ] && {
    echo "[i] python2 $($CHK --version 2>&1 ) already exist as:
$(realpath $CHK)">&2
    exit 0
}

. $D/make_

VER=2.7.18
PKG=Python-$VER.tgz
D=${PKG%.tgz}

echo "[i] make $PKG">&2

../download https://www.python.org/ftp/python/$VER/$PKG $PKG || exit 1

cd $DL

[ -d "$D" ] || tar -xf $PKG

cd $D || exit 2

./configure || exit 3

make -j8 && ln -sf "$D"/python ../python2
