CMD=cd ${GIT_BRANCH} && DISTRONAME=linuxconsole make -f Makefile-docker
GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)

HASDOCKER := $(shell which docker)
SYSTEM_KERNEL := $(shell uname -r)

ifeq ($(HASDOCKER),/usr/bin/docker)
BUILDING=prepare iso
else
BUILDING=nodocker
endif

all: $(BUILDING) #fail prepare iso

echo:
	echo test
	echo "-"$(HASDOCKER)"-"
	echo $(BUILDING)

prepare:
	install -d ${HOME}/${GIT_BRANCH}/multilib
	install -d ${HOME}/${GIT_BRANCH}/x86_64
	install -d ${HOME}/${GIT_BRANCH}/ydfs
	install -d ${HOME}/${GIT_BRANCH}/mate
	install -d ${HOME}/${GIT_BRANCH}/cinnamon
	install -d ${HOME}/${GIT_BRANCH}/linuxconsole
	install -d ${HOME}/${GIT_BRANCH}/kde
	install -d ${HOME}/${GIT_BRANCH}/llvm-multilib
	install -d ${HOME}/${GIT_BRANCH}/opkg
	install -d ${HOME}/iso

	chmod 777 ${HOME}/${GIT_BRANCH}/multilib
	chmod 777 ${HOME}/${GIT_BRANCH}/x86_64
	chmod 777 ${HOME}/${GIT_BRANCH}/ydfs
	chmod 777 ${HOME}/${GIT_BRANCH}/mate
	chmod 777 ${HOME}/${GIT_BRANCH}/cinnamon
	chmod 777 ${HOME}/${GIT_BRANCH}/linuxconsole
	chmod 777 ${HOME}/${GIT_BRANCH}/kde
	chmod 777 ${HOME}/${GIT_BRANCH}/llvm-multilib
	chmod 777 ${HOME}/${GIT_BRANCH}/opkg
	chmod 777 ${HOME}/iso

#	$(CMD) buildenv-docker

sh:
	$(CMD) sh-docker

bash-root:
	$(CMD) bash-root-docker

bash:
	$(CMD) bash-docker

opkg: packages

packages:
	$(CMD) opkg-docker

kde:
	$(CMD) kde-docker

kodi:
	$(CMD) kodi-docker

cinnamon:
	$(CMD) cinnamon-docker

mate:
	$(CMD) mate-docker

virtualbox:
	$(CMD) virtualbox-docker

fast-iso: prepare
	$(CMD) fast-iso-docker

iso: prepare
	$(CMD) iso-docker

fast-files:
	$(CMD) fast-files

updates:
	$(CMD) updates-docker

live-test:
	$(CMD) live-test-docker

check-strip-dir:
	$(CMD) check-strip-dir
	cp $(HOME)/iso/dir-to-strip.txt ${GIT_BRANCH}/data

openxr:
	$(CMD) openxr-docker

iso-devtools:
	$(CMD) iso-devtools-docker

qemu-initramfs-system:
	qemu-system-x86_64 -m size=2000 \
	       	-bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel /boot/vmlinuz-${SYSTEM_KERNEL} \
		-initrd ${HOME}/${GIT_BRANCH}/ydfs/build-x86_64/SYSTEM \
		-append "printk.devkmsg=on printk.time=y console=ttyS0 -device edu -device lkmc_pci_min -device virtio-net-pci root=/dev/ram0 rdinit=/rescue nofcc livecd debug1 quiet text"

qemu-initramfs-rescue:
	qemu-system-x86_64 -m size=2000 \
	       	-bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel ${HOME}/${GIT_BRANCH}/ydfs/build/linux-x86_64-6.18.21/arch/x86_64/boot/bzImage \
		-initrd ${HOME}/${GIT_BRANCH}/ydfs/build-x86_64/initramfs \
		-append "fr azerty rdinit=/busybox/bin/ash /rescue" \
		-cdrom ${HOME}/iso/linuxconsole.iso 
		#-append "rdinit=/busybox/bin/ash"

qemu-initramfs:
	qemu-system-x86_64 -m size=2000 \
	       	-bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel ${HOME}/${GIT_BRANCH}/ydfs/build/linux-x86_64-6.18.21/arch/x86_64/boot/bzImage \
		-initrd ${HOME}/${GIT_BRANCH}/ydfs/build-x86_64/initramfs \
		-append "fr azerty rdinit=/busybox/bin/ash /init-newroot" \
		-cdrom ${HOME}/iso/linuxconsole.iso 
		#-append "rdinit=/busybox/bin/ash"

qemu-azerty-system:
	qemu-system-x86_64 -m size=2000 \
	       	-bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel ${HOME}/${GIT_BRANCH}/ydfs/build/linux-x86_64-SYSTEM/arch/x86_64/boot/bzImage \
		-initrd ${HOME}/${GIT_BRANCH}/ydfs/build-x86_64/SYSTEM \
		-append "rdinit=/busybox/bin/ash /azerty" \
		-cdrom ${HOME}/iso/linuxconsole.iso 

qemu-efi:
	qemu-system-x86_64 -usb -device usb-tablet -enable-kvm -cpu qemu64,avx,pdpe1gb,check,enforce -m size=4000 -bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin -cdrom ${HOME}/iso/linuxconsole.iso

qemu-bios-diskinstall:
	#  qemu-img create -f qcow2 disk.img 10G
	qemu-system-x86_64 -enable-kvm -cpu qemu64,avx,pdpe1gb,check,enforce -device e1000 -m size=4000 -hda disk.img -cdrom ${HOME}/iso/linuxconsole.iso

qemu:
	qemu-system-x86_64 -usb -device usb-tablet -enable-kvm -cpu qemu64,avx,pdpe1gb,check,enforce -m size=4000 -cdrom ${HOME}/iso/linuxconsole.iso

qemu-usb:
	qemu-system-x86_64 -usb -device usb-tablet -m size=2000 -bios ${GIT_BRANCH}/boot-efi/bios/qemu-ovmf/bios/bios.bin \
    -drive if=none,id=usbstick,format=raw,file=${HOME}/iso/linuxconsole.iso  -usb \
    -device usb-ehci,id=ehci \
    -device usb-tablet,bus=usb-bus.0 \
    -device usb-storage,bus=ehci.0,drive=usbstick

nodocker:
	sudo apt-get update 
	sudo apt-get install -y locales ack ant apt-utils autoconf automake python3-blinker bam bc bison bzip2 bzr bindgen cargo cbindgen clang-13 cmake cpio cpuinfo curl cvs docbook-xsl doxygen flex fontforge g++ gawk gcc-multilib genisoimage gettext ghc git g++-multilib gperf gsoap google-mock googletest gi-docgen help2man iasl imagemagick kmod lib32z1 libatomic-ops-dev libbabeltrace-ctf1 libboost-all-dev libboost-dev libclc-13-dev libelf-dev libghc-base-dev libghc-entropy-dev libghc-hslogger-dev libghc-network-dev libghc-random-dev libghc-regex-tdfa-dev libghc-sandi-dev libghc-sha-dev libghc-utf8-string-dev libghc-vector-dev libghc-zlib-dev libmpfr-dev libncurses5-dev libssl-dev libtool libtool-bin libunwind8 libwrap0 libxml-parser-perl lld-13 llvm-13 locales lynx lzma libgtest-dev libgmock-dev libclang-cpp-dev libclang-13-dev make makeself meson mtd-utils nasm openjdk-21-jdk-headless p7zip-full patch pciutils python3-mako rdfind rsync ruby rustc strace subversion syslinux-utils texinfo unicode-data unzip vim valac wget xfonts-utils xmlto xorriso xsltproc xutils-dev xz-utils zlib1g-dev zstd lzip
	cd ${GIT_BRANCH} && make iso

multilib:
	$(CMD) multilib-docker

busybox:
	$(CMD) busybox-docker

linux:
	$(CMD) linux-docker

initramfs:
	$(CMD) initramfs-docker

touch:
	$(CMD) touch-docker

gamejam: prepare
	$(CMD) gamejam-docker

clean: 
	$(CMD) clean-docker
#	rm ${HOME}/${GIT_BRANCH}/ydfs/build-x86_64/initramfs

uninstall: 
	$(CMD) uninstall-docker

buildme: 
	$(CMD) buildme-docker
