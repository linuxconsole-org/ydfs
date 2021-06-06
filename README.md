# About Ydfs

(Your Distro From Scratch) is a tool to build your own linux distribution 

# Build ydfs ISO

(from docker, Linux terminal or Windows powershell)

* mkdir iso
* chmod 777 iso

## Automatic 64 bits ISO Build

* docker run --name ydfs64 -d --mount type=bind,source="$(pwd)"/iso,target=/home/linuxconsole2021/iso yledoare/ydfs28 
* docker logs --tail=10 -f ydfs64
* docker logs -f ydfs64 2>&1 |grep build

## Automatic 32 bits ISO Build

* docker run --name ydfs32 -d --mount type=bind,source="$(pwd)"/iso,target=/home/linuxconsole2021/iso  yledoare/ydfs32
* docker logs --tail=10 -f ydfs32

## Fast 64 bits ISO

* docker run --name ydfs64-fast -e BUILDYDFS=fast -d --mount type=bind,source="$(pwd)"/iso,target=/home/linuxconsole2021/iso  yledoare/ydfs28

## Fast 32 bits ISO

* docker run --name ydfs32-fast -e BUILDYDFS=fast -d --mount type=bind,source="$(pwd)"/iso,target=/home/linuxconsole2021/iso  yledoare/ydfs32

## Write ISO to USB key

* dd if=iso/linuxconsole.iso of=/dev/sdf bs=4M status=progress oflag=sync

## Build and test

* xhost +
* docker run --name ydfs-test -d --mount type=bind,source="$(pwd)"/iso,target=/home/linuxconsole2021/iso -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix  yledoare/ydfs28 
* docker exec -ti ydfs-test c 'cd $HOME/src/ydfs/2.8 ; make live-test'

## Verbose Build, without sharing output ISO on host :

* docker run --name linuxconsole2021 -e DIBAB_VERBOSE_BUILD=YES yledoare/ydfs28

# Manual build

* docker run -d --name ydfs yledoare/ydfs tail -f /dev/null 
* docker exec -ti ydfs bash
* cd $HOME
* git clone https://bitbucket.org/yourdistrofromscratch/ydfs.git
* cd ydfs
* cd 2.8
* make 

# Troubleshooting :

Error when build QT ?
Add "--security-opt seccomp:unconfined" option on Debian Strech
https://stackoverflow.com/questions/52705124/why-qdirexists-do-not-work-in-docker-container

# Features 

* Buildt from user account (no root or sudo needed)
* Fast boot
* Support x86, x86_64 ( arm not tested )
* applications are buildt from source

# Build process 
* Select arch to build
* all packages form packages/list-$ARCH are downloaded then build
* kernel is build
* modules and iso are created
* you can run "make test"

# Custom build

See inside "config.ini" (written when selected ARCH)

You can :

  * Use crosstool-ng instead of host toolchain
  * build your own toolchain
  * enable MENUCONFIG=YES to select your kernel options
