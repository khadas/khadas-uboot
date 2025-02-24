#!/bin/bash

PKG_NAME="u-boot-mainline"
#PKG_VERSION="caad316b3165615f1a4848901811a4a084444c9d"
PKG_SOURCE_DIR="u-boot-$PKG_VERSION"
PKG_SOURCE_NAME="u-boot-$PKG_VERSION.tar.gz"
PKG_SITE="https://github.com/u-boot/u-boot"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_SHA256="87006eb9e3b070894db2f61b01727c1d5abc7d20f9b5db9e2db1d079474afad1"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_NEED_BUILD="YES"

[ "$OLD" ] || {

#PKG_VERSION="0719bf42931033c3109ecc6357e8adb567cb637b"
PKG_SOURCE_DIR="u-boot-$PKG_VERSION"
PKG_SOURCE_NAME="u-boot-$PKG_VERSION.tar.gz"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
#PKG_SHA256="6b196b6592fabed060b7c5b1fa05a743f9be131d11389b762b7d0e2beebbd381"

#PKG_VERSION=v2021.01-rc5
#PKG_VERSION=v2021.01
#PKG_VERSION=v2021.04
#PKG_VERSION=v2021.07-rc1
#PKG_VERSION=v2021.07-rc2
#PKG_VERSION=v2021.07-rc3
#PKG_VERSION=v2021.07-rc4
#PKG_VERSION=v2021.07-rc5

PKG_VERSION=${UBOOT_VER:-v2021.07}

#PKG_VERSION=v2021.10
#PKG_VERSION=10cd8efe1a7eacd63907ba95bd8442bc2cdce461


PKG_SOURCE_DIR="u-boot-$PKG_VERSION"
PKG_SOURCE_NAME="u-boot-$PKG_VERSION.tar.gz"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
#PKG_URL="$PKG_SITE/archive/refs/tags/$PKG_VERSION.tar.gz"
#https://github.com/u-boot/u-boot/archive/refs/tags/v2021.10.tar.gz
}

echo "!!!UBOOT: VER $PKG_VERSION"

make_target_deps(){

	[ -d "$BUILD/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf" ] || {
	    (
	    rm -rf "$BUILD/.stamps/arm-trusted-firmware" 1>/dev/null 2>/dev/null
	    build_package arm-trusted-firmware 
	    )
	}

	[ "$VENDOR" = "Rockchip" ] && {

	    # get ATF

#	    [ -s "$BL31" ] || \
#		BL31=bl31.elf
	    [ -s "$BL31" ] || \
		BL31="../arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf"
	    [ -s "$BL31" ] || \
		BL31="../rkbin/bin/rk33/rk3399_bl31_v1.31.elf"
	    [ -s "$BL31" ] || \
    		BL31=../atf-rk3399/bl31.elf
	    [ -s "$BL31" ] || {
		curl -jkL https://github.com/hyphop/khadas-uboot/releases/download/tc/atf-rk3399.tar.gz | \
		tar -xzf- -C.. && \
    		    BL31=../atf-rk3399/bl31.elf
	    }
	    [ -s "$BL31" ] || {
		BL31=
		echo "[i] BL31 (null)"
		export BL31=
	    }
	    [ -s "$BL31" ] && {
	    export BL31=$(realpath "$BL31")
	    echo "[i] BL31 $BL31"
	    }

	    [ "$OLD" ] && {
	    	# add embed uboot khadas logo
	    	grep -q logo arch/arm/dts/rk3399-khadas-edge.dtsi 2>/dev/null || {
	    	export LOGO_PATH=$(realpath "$PKGS_DIR/$PKG_NAME/files/splash.bmp.gz")
	    	ls -l1 $LOGO_PATH
	    	echo "[i] inject logo to dtb $LOGO_PATH"
	    	sh $PKGS_DIR/$PKG_NAME/files/u-boot.logo.tpl >> arch/arm/dts/rk3399-khadas-edge.dtsi
	    	}
	    }

	}

}

make_target() {

	export PATH="$UBOOT_COMPILER_PATH:$PATH"

	make_target_deps

	make distclean
	make -j${NR_JOBS} CROSS_COMPILE=${UBOOT_COMPILER} ${UBOOT_DEFCONFIG} all

}

post_make_target() {

	[ "$NOPOST" ] && {
	    echo "[i] no post make"
	    return 0
	}

	case "$VENDOR" in

		Amlogic)


		# add embed uboot khadas logo
		# cat u-boot-nodtb.bin u-boot.dtb "$PKGS_DIR/$PKG_NAME/files/splash.bmp.gz" > u-boot.bin
		# new safe method
		echo "[i] inject dtb logo">&2
		dtc -q u-boot.dtb > u-boot.dts
		LOGO_PATH="$PKGS_DIR/$PKG_NAME/files/splash.bmp.gz" \
		sh "$PKGS_DIR/$PKG_NAME/files/u-boot.logo.tpl" >> u-boot.dts
		dtc -q u-boot.dts > u-boot.dtb
		cat u-boot-nodtb.bin u-boot.dtb > u-boot.bin

		# Add firmware
		rm -rf "$BUILD/$PKG_NAME-$PKG_VERSION/fip"
		cp -r "$PKGS_DIR/$PKG_NAME/fip/$KHADAS_BOARD" "$BUILD/$PKG_NAME-$PKG_VERSION/fip"
		cp u-boot.bin fip/bl33.bin
		case "$KHADAS_BOARD" in

			VIM1|VIM2)

			pwd

			for python in "$PYTHON" "$RP/$DOWNLOADS"/python2 python python2 python3 ; do
			[ "$python" ] || continue
			echo "[i] check $python">&2
			which $python && break
			done

			PV=$($python --version)

			case $PV in
			    Python\ 2*)
			    ;;
			    *)
			    FIX=tc/make_020_python2.sh
			    echo "[W] this part need python2 - can fix by scripts/$FIX">&2
			    $RP/$FIX || exit 1
			    python="$RP/$DOWNLOADS"/python2
			    ;;
			esac

			echo $KHADAS_BOARD fip fix ...

			CMD fip/blx_fix.sh fip/bl30.bin fip/zero_tmp fip/bl30_zero.bin fip/bl301.bin fip/bl301_zero.bin fip/bl30_new.bin bl30 || return 1
			CMD $python fip/acs_tool.pyc fip/bl2.bin fip/bl2_acs.bin fip/acs.bin 0 || return 1
			CMD fip/blx_fix.sh fip/bl2_acs.bin fip/zero_tmp fip/bl2_zero.bin fip/bl21.bin fip/bl21_zero.bin fip/bl2_new.bin bl2 || return 1
			CMD fip/aml_encrypt_gxl --bl3enc --input fip/bl30_new.bin || return 1
			CMD fip/aml_encrypt_gxl --bl3enc --input fip/bl31.img || return 1
			CMD fip/aml_encrypt_gxl --bl3enc --input fip/bl33.bin || return 1
			CMD fip/aml_encrypt_gxl --bl2sig --input fip/bl2_new.bin --output fip/bl2.n.bin.sig || return 1
			CMD fip/aml_encrypt_gxl --bootmk --output fip/u-boot.bin --bl2 fip/bl2.n.bin.sig --bl30 fip/bl30_new.bin.enc --bl31 fip/bl31.img.enc --bl33 fip/bl33.bin.enc || return 1

			echo $KHADAS_BOARD fip fix OK

			;;

			VIM3*)

			[ "$KHADAS_BOARD" = "VIM3" ] && \
			aml_encrypt=aml_encrypt_g12b
			[ "$KHADAS_BOARD" = "VIM3L" ] && \
			aml_encrypt=aml_encrypt_g12a

			fip/blx_fix.sh fip/bl30.bin fip/zero_tmp fip/bl30_zero.bin fip/bl301.bin fip/bl301_zero.bin fip/bl30_new.bin bl30
			fip/blx_fix.sh fip/bl2.bin fip/zero_tmp fip/bl2_zero.bin fip/acs.bin fip/bl21_zero.bin fip/bl2_new.bin bl2
			fip/${aml_encrypt} --bl30sig --input fip/bl30_new.bin --output fip/bl30_new.bin.g12a.enc --level v3
			fip/${aml_encrypt} --bl3sig --input fip/bl30_new.bin.g12a.enc --output fip/bl30_new.bin.enc --level v3 --type bl30
			fip/${aml_encrypt} --bl3sig --input fip/bl31.img --output fip/bl31.img.enc --level v3 --type bl31
			fip/${aml_encrypt} --bl3sig --input fip/bl33.bin --compress lz4 --output fip/bl33.bin.enc --level v3 --type bl33 --compress lz4
			fip/${aml_encrypt} --bl2sig --input fip/bl2_new.bin --output fip/bl2.n.bin.sig
			fip/${aml_encrypt} --bootmk \
				--output fip/u-boot.bin \
				--bl2 fip/bl2.n.bin.sig \
				--bl30 fip/bl30_new.bin.enc \
				--bl31 fip/bl31.img.enc \
				--bl33 fip/bl33.bin.enc \
				--ddrfw1 fip/ddr4_1d.fw \
				--ddrfw2 fip/ddr4_2d.fw \
				--ddrfw3 fip/ddr3_1d.fw \
				--ddrfw4 fip/piei.fw \
				--ddrfw5 fip/lpddr4_1d.fw \
				--ddrfw6 fip/lpddr4_2d.fw \
				--ddrfw7 fip/diag_lpddr4.fw \
				--ddrfw8 fip/aml_ddr.fw \
				--ddrfw9 fip/lpddr3_1d.fw \
				--level v3
			;;
			esac
		;;
		Rockchip)

BS=.
UBOOT_SD_MMC=u-boot.mmc.64.bin
UBOOT_SD_MMC0=u-boot.sd.bin
UBOOT_SPI=u-boot.spi.bin
UBOOT_PAYLOAD=0x40000

[ "$OLD" ] || {
#[ "" ] && {
		D=rk3399-khadas-edge-v.dtb
		DTS=/tmp/${D%.*}.dts
		DTB="arch/arm/dts/$D"
		dtc -q $DTB > $DTS

		grep khadas_logo $DTS || {
		echo "[i] inject dtb logo">&2
		LOGO_PATH="$PKGS_DIR/$PKG_NAME/files/splash.bmp.gz" \
		sh "$PKGS_DIR/$PKG_NAME/files/u-boot.logo.tpl" >> $DTS
		dtc -q $DTS > $DTB
		#cp $DTB u-boot.dtb
		( cd $BS
		dtc -q u-boot.its > u-boot.itb
		./tools/mkimage -E -f u-boot.its -p 0x0 u-boot.itb
		)
		}
}

[ -d "$BS/tpl" ] && {
echo "[i] TPL+SPL SPI"
$BS/tools/mkimage -n rk3399 -T rkspi -d $BS/tpl/u-boot-tpl-dtb.bin $UBOOT_SPI
cat $BS/spl/u-boot-spl-dtb.bin >> $UBOOT_SPI
ls -l1 $UBOOT_SPI
truncate -s $((UBOOT_PAYLOAD-0)) $UBOOT_SPI
cat $BS/u-boot.itb >> $UBOOT_SPI
gzip -c9 $UBOOT_SPI > $UBOOT_SPI.gz
ls -l1 $UBOOT_SPI*
}

[ -d "$BS/tpl" ] || {
echo "[i] SPL SPI"
$BS/tools/mkimage -n rk3399 -T rkspi -d $BS/spl/u-boot-spl-dtb.bin $UBOOT_SPI
ls -l1 $UBOOT_SPI
truncate -s $((UBOOT_PAYLOAD-0)) $UBOOT_SPI
cat $BS/u-boot.itb >> $UBOOT_SPI
gzip -c9 $UBOOT_SPI > $UBOOT_SPI.gz
ls -l1 $UBOOT_SPI*
}

[ -d "$BS/tpl" ] && {
echo "[i] TPL+SPL SD"
$BS/tools/mkimage -n rk3399 -T rksd -d $BS/tpl/u-boot-tpl-dtb.bin  $UBOOT_SD_MMC || DIE
ls -l1 $UBOOT_SD_MMC
cat $BS/spl/u-boot-spl-dtb.bin >> $UBOOT_SD_MMC
truncate -s $((UBOOT_PAYLOAD-64*512))  $UBOOT_SD_MMC
cat $BS/u-boot.itb >> $UBOOT_SD_MMC
gzip -c9 $UBOOT_SD_MMC > $UBOOT_SD_MMC.gz
dd if=/dev/zero count=64 of=$UBOOT_SD_MMC0 1>/dev/null 2>/dev/null
cat $UBOOT_SD_MMC >> $UBOOT_SD_MMC0
ls -l1 $UBOOT_SD_MMC*

}

[ -d "$BS/tpl" ] || {
echo "[i] SPL SD"
$BS/tools/mkimage -n rk3399 -T rksd -d $BS/spl/u-boot-spl-dtb.bin  $UBOOT_SD_MMC || DIE
ls -l1 $UBOOT_SD_MMC
truncate -s $((UBOOT_PAYLOAD-64*512))  $UBOOT_SD_MMC
cat $BS/u-boot.itb >> $UBOOT_SD_MMC
gzip -c9 $UBOOT_SD_MMC > $UBOOT_SD_MMC.gz
dd if=/dev/zero count=64 of=$UBOOT_SD_MMC0 1>/dev/null 2>/dev/null
cat $UBOOT_SD_MMC >> $UBOOT_SD_MMC0
ls -l1 $UBOOT_SD_MMC*
}

		;;
	esac
}

makeinstall_target() {
	mkdir -p $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
	rm -rf $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD/*
	cd $BUILD/$PKG_NAME-$PKG_VERSION

	case "$VENDOR" in
		Amlogic)
		cp fip/u-boot.bin $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
		cp fip/u-boot.bin.sd.bin $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
		;;
		Rockchip)
#		cp idbloader.img $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
#		cp uboot.img $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
#		cp trust.img $BUILD_IMAGES/$PKG_NAME/$KHADAS_BOARD
		;;
	esac
}
