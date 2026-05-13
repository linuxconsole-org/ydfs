SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/sun4u/sparc64/ \
				  -e s/arm.*/arm/ -e s/sa110/arm/ \
				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
				  -e s/sh[234].*/sh/ )
ARCH		?= $(SUBARCH)
include config.ini

THEMODULENAME1=$(shell echo ${MODULES} | sed -e s/${ARCH}//g -e s/drivers-// -e s/firmware-// )
THEMODULENAME = $(subst -, ,$(THEMODULENAME1))
export OLDPATH=${PATH}
export DIBAB_ARCH=${ARCH}
export ARCH
export KERNEL3
export MEDIA
export BUILDMODULES
ifeq ($(BUILDMODULES),YES)
  export YDFS_MODULES
else
  YDFS_MODULES=""
endif

BUILDYDFS=$(shell env | grep BUILDYDFS | cut -d'=' -f2)

export BUILDME
export SUBARCH
export BUILD_DESKTOP
export DISTRONAME
export SLEEPTIME
export SKIPOPKG
export SEND_BUILD_LOG
export TOOLCHAIN
export HOME_DIBAB
ifeq ($(GIT_BRANCH),)
  export YDFS=$(shell basename ${PWD})
else
  export YDFS=$(GIT_BRANCH)
endif
export DIBAB_VERBOSE_BUILD
export SEND_OPKG
export MKSQUASHFS_OPT
export MENUCONFIG
export BUILD_TOOLCHAIN
export SKIP_OPKG_ERROR
export CROSSTOOL
export GNU=gnu
export VENDOR=unknown
ifeq ($(ARCH),x86)
  export CPU=i686
else
  export CPU=${ARCH}
endif
ifeq ($(ARCH),arm)
KNAME=zImage
export LIST=${SUBARCH}
# export GNU=uclibcgnueabi
export GNU=gnueabi
export TOOLCHAIN_PREFIX=arm
export VENDOR=unknown
  ifeq ($(TOOLCHAIN),FriendlyARM)
    GCCPATH = ${HOME}/ydfs/toolchain/arm/opt/FriendlyARM/toolschain/4.4.3/bin/
    export PATH := ${PATH}:${GCCPATH}
    export CROSS_PREFIX=arm-linux
    export CROSS_COMPILE=arm-linux-
    export CC=${CROSS_COMPILE}gcc -march=armv4t -mtune=arm920t
  endif
  ifeq ($(TOOLCHAIN),buildroot)
    GCCPATH = ${HOME}/ydfs/buildroot-2011.08/output/host/usr/bin/
    export PATH := ${PATH}:${GCCPATH}
    export PATH
    export CROSS_PREFIX=arm-linux
    export CROSS_COMPILE=arm-linux-
    export CC=${CROSS_COMPILE}gcc -march=armv4t -mtune=arm920t
  endif
  ifeq ($(TOOLCHAIN),crosstool-ng)
    GCCPATH = ${HOME}/ydfs/x-tools/arm-${VENDOR}-linux-${GNU}/bin/
    export PATH := ${PATH}:${GCCPATH}
    export PATH
    export CROSS_PREFIX=arm-${VENDOR}-linux-${GNU}
    export CROSS_COMPILE=arm-${VENDOR}-linux-${GNU}-
    export CC=${CROSS_COMPILE}gcc -march=armv4t -mtune=arm920t
  endif
  ifeq ($(SUBARCH),$(filter $(SUBARCH),raspi raspi-qemu))
  ifeq ($(TOOLCHAIN),crosstool-ng)
     GCCPATH = ${HOME}/ydfs/x-tools/arm-${VENDOR}-linux-${GNU}/bin/
     export CROSS_COMPILE=${TOOLCHAIN_PREFIX}-${VENDOR}-linux-${GNU}-
     export CROSS_PREFIX=${TOOLCHAIN_PREFIX}-${VENDOR}-linux-${GNU}
  else
     # export VENDOR=bcm2708
     # GCCPATH = ${HOME}/ydfs/tools-master/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/
     #export VENDOR=tools6h
     #export GNUPATH=gnueabihf
     #GCCPATH=${HOME}/ydfs/x-tools6h/arm-unknown-linux-gnueabihf/bin
     #export CROSS_COMPILE=${ARCH}-unknown-linux-${GNU}-
     #export CROSS_PREFIX=${ARCH}-unknown-linux-${GNU}
     #export CC=${CROSS_COMPILE}gcc  -Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s
     export VENDOR=linaro-arm
     TOOLCHAIN_PREFIX=gcc
     export GNU=gnueabihf
     export GNUPATH=gnueabihf-raspbian
     GCCPATH=${HOME}/ydfs/tools-master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/
     export CROSS_COMPILE=${ARCH}-linux-${GNU}-
     export CROSS_PREFIX=${ARCH}-linux-${GNU}
     export CC=${CROSS_COMPILE}gcc -Ofast -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s
  endif
    export PATH := ${PATH}:${GCCPATH}
    export PATH
    export CC=${CROSS_COMPILE}gcc
    export CXX=${CROSS_COMPILE}g++
  endif
else
KNAME=bzImage
export LIST=${ARCH}
  ifeq ($(TOOLCHAIN),crosstool-ng)
    export CROSS_PREFIX=${CPU}-ydfs-linux-gnu
    export CROSS_COMPILE=${CROSS_PREFIX}-
    GCCPATH = ${HOME}/ydfs/x-tools/${CROSS_PREFIX}/bin/
    export PATH := ${PATH}:${GCCPATH}
    export CC=${CROSS_COMPILE}gcc 
    export MENUCONFIG
  endif
endif
# INITRAMFS=$(shell echo $(KERNEL3) | tr -d '.')
INITRAMFS=initramfs
ISOPATH=$(shell echo $(ISOTMP)/$(DISTRONAME).$(LCBUILD)-$(ARCH)$(MEDIA).iso)
export ISOPATH
all:
  ifeq ($(NOBUILD),OK)
	@echo "NOBUILD ! "
	tail -f /dev/null
  endif
	@echo "Usage : "
	@echo "make iso "
	@echo "make test "
	@echo "make modules "
	@echo "make opkg "
	echo "BUILDYDFS is" ${BUILDYDFS}
	tail -f /dev/null
isodep: config.ini toolchain ${HOME}/${ARCH}/buildenv linux busybox initramfs core firmware drivers $(DISTRONAME)
sleep:
	@echo "Sleeping $SLEEPTIME seconds .. "
	sleep ${SLEEPTIME}
 
${HOME}/ydfs/x-tools/i386-unknown-linux-uclibc/bin/i386-unknown-linux-uclibc-gcc:
	bash scripts/make_busybox_toolchain
busybox-toolchain: ${HOME}/ydfs/x-tools/i386-unknown-linux-uclibc/bin/i386-unknown-linux-uclibc-gcc

busybox: ${HOME}/ydfs/build/busybox-${ARCH}-${BUSYBOX}/_install

${HOME}/ydfs/build/busybox-${ARCH}-${BUSYBOX}/_install:
	bash scripts/make_busybox ${BUSYBOX}

${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config:
	bash scripts/make_linux

${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/arch/${ARCH}/boot/${KNAME}: scripts/make_linux # ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config config/kernel-${ARCH}/config
	@echo "build " ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/arch/${ARCH}/boot/${KNAME}
	bash scripts/make_linux

linux: ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/arch/${ARCH}/boot/${KNAME} 

${HOME}/ydfs/build-${ARCH}/${INITRAMFS}: scripts/make_initramfs # init-${ARCH}/ydfs/detect/media init-${ARCH}/ydfs/detect/hardware init-${ARCH}/ydfs/detect/modules init-${ARCH} init-${ARCH}/etc/init.d/rcS init-${ARCH}/etc/profile scripts/make_initramfs
	bash scripts/make_initramfs

initramfs: ${HOME}/ydfs/build-${ARCH}/${INITRAMFS} scripts/make_linux
initramfs2: 
	CUSTOMINIT=OK bash scripts/make_initramfs

crosstool-ng-x86_64:
	@echo Bug with recursion
	echo run bash scripts/make_crosstool-ng-x86_64
	#bash scripts/make_crosstool-ng-x86_64
${GCCPATH}: 
	bash scripts/make_toolchain
toolchain: ${GCCPATH}
iso: isodep wineprogs ${ISOPATH} # sleep
metalink:
	bash scripts/iso_to_metalink

${ISOPATH}: ${HOME}/ydfs/build-${ARCH}/${INITRAMFS} ${LCMBUILD}/${ARCH}.squashfs ${LCMBUILD}/mate-${ARCH}.squashfs ${LCMBUILD}/firmware-${ARCH}.squashfs # ${LCMBUILD}/kde-${ARCH}.squashfs # config.ini #  ${LCMBUILD}
	bash scripts/make_iso

config.ini:
	bash scripts/make_config_ini
	ls -l config.ini
	touch -t 2301011536 config.ini
live-test:
	bash scripts/make_live_test
test-arm:
	bash scripts/make_test_arm
logs:
	bash scripts/upload_logs
desktop-menus:
	bash scripts/install-desktop-menus
wineprogs:
	bash scripts/get_wine_progs
test:
	bash scripts/make_test
fast-files:
	# YDFS=${YDFS} bash scripts/make_fast_files
	bash scripts/make_fast_files
test-liveusb:
	bash scripts/make_test bootusb
test2:
	bash scripts/make_test curses
cleanmultilib:
	bash scripts/make_clean_multilib
distclean:
	bash scripts/make_distclean
clean-opkg:
	bash scripts/make_clean_opkg
clean:
	bash scripts/make_clean
uninstall:
	bash scripts/uninstall-package SuperTuxKart-1.4-src
ifeq ($(ARCH),x86)
	rm ${ISOPATH}
	rm ${LCMBUILD}/*
endif
ifeq ($(ARCH),arm)
	rm -fR ${HOME}/${ARCH}/*
endif
	
${HOME}/${ARCH}/buildenv: packages/list-${LIST}
	echo "Build packages/list-${LIST}"
	echo "BUILDYDFS is" ${BUILDYDFS}
	bash scripts/make_packages ${LIST}
core: ${LCMBUILD}/${ARCH}.squashfs 
drivers: ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config ${LCMBUILD}/drivers-${ARCH}.squashfs
firmware: ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config ${LCMBUILD}/firmware-${ARCH}.squashfs

${LCMBUILD}/firmware-${ARCH}.squashfs: ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config
	bash scripts/make_firmwares
${LCMBUILD}/drivers-${ARCH}.squashfs: ${HOME}/ydfs/build/linux-${ARCH}-${KERNEL3}/.config
	bash scripts/make_drivers
${LCMBUILD}/${ARCH}.squashfs: packages/list-${LIST} scripts/make_modules
	bash scripts/make_modules

check:
	bash scripts/check_url
archives: ${HOME}/ydfs/archives/${ARCH}-${VENDOR}-linux-toolchain.tar.bz2

${HOME}/ydfs/archives/${ARCH}-${VENDOR}-linux-toolchain.tar.bz2:
	bash scripts/make_archives
updates: packages/list-updates
	bash scripts/make_packages updates

kodi: ${LCMBUILD}/kodi-${ARCH}.squashfs
${LCMBUILD}/kodi-${ARCH}.squashfs : packages/list-kodi
	bash scripts/make_packages kodi
	bash scripts/make_module kodi
hackerOS: packages/list-hackerOS
	bash scripts/make_packages hackerOS
	bash scripts/make_module hackerOS

modules: $(shell echo ${YDFS_MODULES})

kde: ${LCMBUILD}/kde-${ARCH}.squashfs
${LCMBUILD}/kde-${ARCH}.squashfs : packages/list-kde
	bash scripts/make_packages kde
	bash scripts/make_module kde

browsers: ${LCMBUILD}/browsers-${ARCH}.squashfs
${LCMBUILD}/browsers-${ARCH}.squashfs : packages/list-browsers
	bash scripts/make_packages browsers
	bash scripts/make_module browsers

lxqt: ${LCMBUILD}/lxqt-${ARCH}.squashfs
${LCMBUILD}/lxqt-${ARCH}.squashfs : packages/list-lxqt
	bash scripts/make_packages lxqt
	bash scripts/make_module lxqt

gnome-flashback: ${LCMBUILD}/gnome-flashback-${ARCH}.squashfs
${LCMBUILD}/gnome-flashback-${ARCH}.squashfs : packages/list-gnome-flashback
	bash scripts/make_packages gnome-flashback
	bash scripts/make_module gnome-flashback

lxde: ${LCMBUILD}/lxde-${ARCH}.squashfs
${LCMBUILD}/lxde-${ARCH}.squashfs : packages/list-lxde
	bash scripts/make_packages lxde
	bash scripts/make_module lxde

kdegames: ${LCMBUILD}/kdegames-${ARCH}.squashfs
${LCMBUILD}/kdegames-${ARCH}.squashfs : packages/list-kdegames
	bash scripts/make_packages kdegames
	bash scripts/make_module kdegames

libreoffice: ${LCMBUILD}/libreoffice-${ARCH}.squashfs
${LCMBUILD}/libreoffice-${ARCH}.squashfs : packages/list-libreoffice
	bash scripts/make_packages libreoffice
	bash scripts/make_module libreoffice

xfce: ${LCMBUILD}/xfce-${ARCH}.squashfs
${LCMBUILD}/xfce-${ARCH}.squashfs : packages/list-xfce
	bash scripts/make_packages xfce
	bash scripts/make_module xfce

virtualbox: ${LCMBUILD}/virtualbox-${ARCH}.squashfs
${LCMBUILD}/virtualbox-${ARCH}.squashfs : packages/list-virtualbox
	bash scripts/make_packages virtualbox
	bash scripts/make_module virtualbox

games: ${LCMBUILD}/games-${ARCH}.squashfs
${LCMBUILD}/games-${ARCH}.squashfs : packages/list-games
	bash scripts/make_packages games
	bash scripts/make_module games

video: ${LCMBUILD}/video-${ARCH}.squashfs
${LCMBUILD}/video-${ARCH}.squashfs : packages/list-video
	bash scripts/make_packages video
	bash scripts/make_module video

music: ${LCMBUILD}/music-${ARCH}.squashfs
${LCMBUILD}/music-${ARCH}.squashfs : packages/list-music
	bash scripts/make_packages music
	bash scripts/strip_module music
	bash scripts/make_module music

cinnamon: ${LCMBUILD}/cinnamon-${ARCH}.squashfs
${LCMBUILD}/cinnamon-${ARCH}.squashfs : packages/list-cinnamon
	bash scripts/make_packages cinnamon
	bash scripts/strip_module cinnamon
	bash scripts/make_module cinnamon

vst: ${LCMBUILD}/vst-${ARCH}.squashfs
${LCMBUILD}/vst-${ARCH}.squashfs : packages/list-vst
	bash scripts/make_packages vst
	bash scripts/strip_module vst
	bash scripts/make_module vst

mate: ${LCMBUILD}/mate-${ARCH}.squashfs
${LCMBUILD}/mate-${ARCH}.squashfs : packages/list-mate
	bash scripts/make_packages mate
	bash scripts/strip_module mate
	bash scripts/make_module mate

devtools: ${LCMBUILD}/devtools-${ARCH}.squashfs
${LCMBUILD}/devtools-${ARCH}.squashfs : packages/list-devtools
	bash scripts/make_packages devtools
	bash scripts/make_module devtools

accessibility: ${LCMBUILD}/accessibility-${ARCH}.squashfs
${LCMBUILD}/accessibility-${ARCH}.squashfs : packages/list-accessibility
	bash scripts/make_packages accessibility
	bash scripts/make_module accessibility

emulators: ${LCMBUILD}/emulators-${ARCH}.squashfs
${LCMBUILD}/emulators-${ARCH}.squashfs : packages/list-emulators
	bash scripts/make_packages emulators
	bash scripts/make_module emulators

multimedia: ${LCMBUILD}/multimedia-${ARCH}.squashfs
${LCMBUILD}/multimedia-${ARCH}.squashfs : packages/list-multimedia
	bash scripts/make_packages multimedia
	bash scripts/make_module multimedia

network: ${LCMBUILD}/network-${ARCH}.squashfs
${LCMBUILD}/network-${ARCH}.squashfs : packages/list-network
	bash scripts/make_packages network
	bash scripts/make_module network

graphics: ${LCMBUILD}/graphics-${ARCH}.squashfs
${LCMBUILD}/graphics-${ARCH}.squashfs : packages/list-graphics
	bash scripts/make_packages graphics
	bash scripts/make_module graphics

fps: ${LCMBUILD}/fps-${ARCH}.squashfs
${LCMBUILD}/fps-${ARCH}.squashfs : packages/list-fps
	bash scripts/make_packages fps
	bash scripts/make_module fps

chromium: ${LCMBUILD}/chromium-${ARCH}.squashfs
${LCMBUILD}/chromium-${ARCH}.squashfs : packages/list-chromium
	bash scripts/make_packages chromium
	bash scripts/make_module chromium

firefox: ${LCMBUILD}/firefox-${ARCH}.squashfs

firefox: ${LCMBUILD}/firefox-${ARCH}.squashfs
${LCMBUILD}/firefox-${ARCH}.squashfs : packages/list-firefox
	bash scripts/make_packages firefox
	bash scripts/make_module firefox

office: ${LCMBUILD}/office-${ARCH}.squashfs
${LCMBUILD}/office-${ARCH}.squashfs : packages/list-office
	bash scripts/make_packages office
	bash scripts/make_module office

clean-linuxconsole:
	# rm ${HOME}/ydfs/build/modules/linuxconsole-${ARCH}.squashfs
	rm -fR ${HOME}/linuxconsole/
	FORCEBUILD=OK make linuxconsole

unfa: ${LCMBUILD}unfa-${ARCH}.squashfs
${LCMBUILD}unfa-${ARCH}.squashfs : packages/list-unfa
	bash scripts/make_packages unfa
	bash scripts/make_module unfa
   
multilib: 
	bash scripts/make_multilib # || bash scripts/make_multilib
dist: 
	bash scripts/make_opkg_filelist opkg
fixopkg:
	bash scripts/make_thunderbird
	bash scripts/make_fixes
#	bash scripts/make_firefox
#	bash scripts/make_custom_opkg playonlinux
	bash scripts/make_custom_opkg flash
#	bash scripts/make_custom_opkg arabic
#	bash scripts/make_custom_opkg spring
	bash scripts/make_opkg_filelist opkg
buildenv: ${HOME}/${ARCH}/buildenv
# opkg: ${HOME}/${ARCH}/buildenv ${HOME}/ydfs/opkg/Packages
opkg: ${HOME}/ydfs/opkg/Packages
${HOME}/ydfs/opkg/Packages : packages/list-opkg-${DISTRONAME}
ifeq ($(BUILDOPKG),YES)
	cp packages/list-opkg-${DISTRONAME} packages/list-opkg
	bash scripts/make_packages opkg
	bash scripts/make_opkg_filelist opkg
else
	echo "Skip opkg"
endif
   

${DISTRONAME}: ${LCMBUILD}${DISTRONAME}-${ARCH}.squashfs
#${DISTRONAME}: ${LCMBUILD}devtools-${ARCH}.squashfs
${LCMBUILD}${DISTRONAME}-${ARCH}.squashfs : packages/list-${DISTRONAME}
	bash scripts/make_packages ${DISTRONAME}
	bash scripts/make_module ${DISTRONAME}
   
papyrus: ${LCMBUILD}papyrus-${ARCH}.squashfs

lanpower: ${LCMBUILD}lanpower-${ARCH}.squashfs
${LCMBUILD}lanpower-${ARCH}.squashfs : packages/list-lanpower
	bash scripts/make_packages lanpower
	bash scripts/make_module lanpower

clean-lanpower:
  #pour mettre à zéro la compil lanpower
	# rm ${HOME}/ydfs/build/modules/lanpower-${ARCH}.squashfs
	rm -fR ${HOME}/lanpower/
	FORCEBUILD=OK make lanpower
   
papyrus: ${LCMBUILD}papyrus-${ARCH}.squashfs
${LCMBUILD}papyrus-${ARCH}.squashfs : packages/list-papyrus
	bash scripts/make_packages papyrus
	bash scripts/make_module papyrus
   
vm: ${LCMBUILD}vm-${ARCH}.squashfs
${LCMBUILD}vm-${ARCH}.squashfs : packages/list-vm
	bash scripts/make_packages vm
	bash scripts/make_module vm

pantheon: ${LCMBUILD}pantheon-${ARCH}.squashfs
${LCMBUILD}pantheon-${ARCH}.squashfs : packages/list-pantheon
	bash scripts/make_packages pantheon
	bash scripts/make_module pantheon
   
kodi: ${LCMBUILD}kodi-${ARCH}.squashfs
${LCMBUILD}kodi-${ARCH}.squashfs : packages/list-kodi
	bash scripts/make_packages kodi
	bash scripts/make_module kodi

antivirus: ${LCMBUILD}antivirus-${ARCH}.squashfs
${LCMBUILD}antivirus-${ARCH}.squashfs : packages/list-antivirus
	bash scripts/make_packages antivirus
	bash scripts/make_module antivirus

archive:
	cd ..
	tar czvf linuxconsole-2.4.tar.gz --exclude config.ini --exclude .git 2.4

openxr: ${LCMBUILD}/openxr-${ARCH}.squashfs
${LCMBUILD}/openxr-${ARCH}.squashfs : packages/list-openxr
	bash scripts/make_packages openxr
	SKIP_STRIP=OK bash scripts/make_module openxr

check-strip-dir:
	bash scripts/check_strip_dir > $(HOME)/iso/dir-to-strip.txt
