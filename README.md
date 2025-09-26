# About Ydfs

(Your Distro From Scratch) is a tool to build your own linux distribution 

# Warning

This 2.10 banch is using an archived realease : https://github.com/yledoare/ydfs
This static script is used : https://github.com/linuxconsole-org/ydfs/blob/2.10/2.10/build-lc2024

# About 32 bits build

To build 32 bits ISO, you must switch to 2.10-32bits branch :

* git checkout 2.10-32bits

# Build with Docker

* install -d $HOME/iso
* chmod 777 $HOME/iso
* cd 2.10

# Full Build (32 & 64 bits)

* docker-compose up -d

# Fast Build (32 & 64 bits)

* BUILDYDFS="fast" docker-compose up -d

# Manual build

* sudo apt-get install -y vim ack wget openjdk-21-jdk-headless libncurses5-dev  rustc python3-mako cargo gcc-multilib g++-multilib ant libssl-dev libwrap0 gsoap meson libghc-sandi-dev libghc-regex-tdfa-dev libghc-base-dev libghc-sha-dev libbabeltrace-ctf1 xz-utils libxml-parser-perl patch libunwind8 libclc-dev ftjam locales syslinux-utils ghc libghc-random-dev libghc-zlib-dev libghc-entropy-dev libghc-utf8-string-dev ghc libghc-vector-dev libghc-network-dev libghc-hslogger-dev makeself iasl doxygen p7zip-full xutils-dev xmlto libelf-dev imagemagick bam fontforge ruby libboost-all-dev libboost-dev nasm libatomic-ops-dev unzip bc lynx cmake xfonts-utils xsltproc zlib1g-dev gperf bzr unicode-data gettext docbook-xsl make mtd-utils pciutils texinfo bzip2 subversion git gawk bison flex automake autoconf libtool-bin libtool cvs lzma g++ genisoimage libmpfr-dev locales apt-utils llvm-13 vim cpio curl rdfind rsync kmod xorriso

* cd 2.10

# For fast option
* export BUILDYDFS=fast

* make iso
