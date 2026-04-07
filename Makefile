CMD=cd 2.12 && make -f Makefile-docker

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
	install -d ${HOME}/2.12/multilib
	install -d ${HOME}/2.12/x86_64
	install -d ${HOME}/2.12/ydfs
	install -d ${HOME}/2.12/mate
	install -d ${HOME}/2.12/kde
	install -d ${HOME}/2.12/llvm-multilib
	install -d ${HOME}/2.12/opkg
	install -d ${HOME}/iso

	chmod 777 ${HOME}/2.12/multilib
	chmod 777 ${HOME}/2.12/x86_64
	chmod 777 ${HOME}/2.12/ydfs
	chmod 777 ${HOME}/2.12/mate
	chmod 777 ${HOME}/2.12/kde
	chmod 777 ${HOME}/2.12/llvm-multilib
	chmod 777 ${HOME}/2.12/opkg
	chmod 777 ${HOME}/iso

#	$(CMD) buildenv-docker

sh:
	$(CMD) sh-docker

bash:
	$(CMD) bash-docker

opkg: packages

packages:
	$(CMD) opkg-docker

kde:
	$(CMD) kde-docker

kodi:
	$(CMD) kodi-docker

mate:
	$(CMD) mate-docker

virtualbox:
	$(CMD) virtualbox-docker

iso: prepare
	$(CMD) iso-docker

updates:
	$(CMD) updates-docker

live-test:
	$(CMD) live-test-docker

openxr:
	$(CMD) openxr-docker

iso-devtools:
	$(CMD) iso-devtools-docker

qemu-initrd-system:
	qemu-system-x86_64 -m size=2000  -D ./qemu-debug-log -monitor pty \
	       	-bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel /boot/vmlinuz-${SYSTEM_KERNEL} \
		-initrd /home/yann/src/ydfs/initrd/initrd \
		-append "root=/dev/ram0 rootfstype=ramfs init=/init2 rdinit=/init2 console=ttyS0 "
		#-append "nopat nokaslr norandmaps printk.devkmsg=on printk.time=y console=ttyS0 -device edu -device lkmc_pci_min -device virtio-net-pci,netdev=net0 root=/dev/ram0 rdinit=/init2 nofcc livecd debug1 quiet text"

qemu-initramfs-system:
	qemu-system-x86_64 -m size=2000 \
	       	-bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel /boot/vmlinuz-${SYSTEM_KERNEL} \
		-initrd ${HOME}/2.12/ydfs/build-x86_64/61810 \
		-append "printk.devkmsg=on printk.time=y console=ttyS0 -device edu -device lkmc_pci_min -device virtio-net-pci,netdev=net0 root=/dev/ram0 rdinit=/init2 nofcc livecd debug1 quiet text"
qemu-initramfs:
	qemu-system-x86_64 -m size=2000 \
	       	-bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel ${HOME}/2.12/ydfs/build/linux-x86_64-6.18.10/arch/x86_64/boot/bzImage \
		-initrd ${HOME}/2.12/ydfs/build-x86_64/61810 \
		-append "rdinit=/init2 nofcc livecd debug1 quiet text"

qemu2:
	qemu-system-x86_64 -D ./qemu-debug-log -monitor pty -m size=2000 \
	       	-bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin \
	       	-kernel ${HOME}/2.12/ydfs/build/linux-x86_64-6.18.21/arch/x86_64/boot/bzImage \
		-initrd ${HOME}/2.12/ydfs/build-x86_64/61821 \
		-append "rdinit=exec /busybox/bin/ash /init4"
qemu:
	qemu-system-x86_64 -usb -device usb-tablet -m size=2000 -bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin -cdrom ${HOME}/iso/linuxconsole.iso

qemu-usb:
	qemu-system-x86_64 -usb -device usb-tablet -m size=2000 -bios 2.12/boot-efi/bios/qemu-ovmf/bios/bios.bin \
    -drive if=none,id=usbstick,format=raw,file=${HOME}/iso/linuxconsole.iso  -usb \
    -device usb-ehci,id=ehci \
    -device usb-tablet,bus=usb-bus.0 \
    -device usb-storage,bus=ehci.0,drive=usbstick

nodocker:
	sudo apt-get update 
	sudo apt-get install -y locales ack ant apt-utils autoconf automake python3-blinker bam bc bison bzip2 bzr bindgen cargo cbindgen clang-13 cmake cpio cpuinfo curl cvs docbook-xsl doxygen flex fontforge g++ gawk gcc-multilib genisoimage gettext ghc git g++-multilib gperf gsoap google-mock googletest gi-docgen help2man iasl imagemagick kmod lib32z1 libatomic-ops-dev libbabeltrace-ctf1 libboost-all-dev libboost-dev libclc-13-dev libelf-dev libghc-base-dev libghc-entropy-dev libghc-hslogger-dev libghc-network-dev libghc-random-dev libghc-regex-tdfa-dev libghc-sandi-dev libghc-sha-dev libghc-utf8-string-dev libghc-vector-dev libghc-zlib-dev libmpfr-dev libncurses5-dev libssl-dev libtool libtool-bin libunwind8 libwrap0 libxml-parser-perl lld-13 llvm-13 locales lynx lzma libgtest-dev libgmock-dev libclang-cpp-dev libclang-13-dev make makeself meson mtd-utils nasm openjdk-21-jdk-headless p7zip-full patch pciutils python3-mako rdfind rsync ruby rustc strace subversion syslinux-utils texinfo unicode-data unzip vim valac wget xfonts-utils xmlto xorriso xsltproc xutils-dev xz-utils zlib1g-dev zstd lzip
	cd 2.12 && make iso

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

uninstall: 
	$(CMD) uninstall-docker

buildme: 
	$(CMD) buildme-docker
