# https://linuxconfig.org/how-to-uncompress-and-list-an-initramfs-content-on-linux
# tested arg /media/yann/FBAF-A120/linuxmint-22.3-xfce-64bit.iso
# https://mir.archlinux.fr/iso/latest/archlinux-x86_64.iso
[ "$1" = "" ] && echo "Needs iso !" && exit 1

mount | grep loop0 || udisksctl loop-setup -f $1 || exit 1

sleep 1

find /media/$(whoami)/ -name initrd.lz |while read initramfs
#find /media/$(whoami)/ -name initramfs-linux.img  |while read initramfs
do
   echo $initramfs
   initramfsdir=$(dirname "$initramfs")
   install -d $HOME/extract-initramfs
   cd $HOME/extract-initramfs
   cpio -tvF "$initramfs" 1>/dev/null 2>cpio.log
   BLOCS=$(grep blocs cpio.log | cut -d' ' -f1)
   echo "Blocs : $BLOCS"
   dd if="$initramfs" skip=$BLOCS of=initramfs2 || exit 1
   cpio -tvF initramfs2 1>/dev/null 2>cpio.log
   BLOCS=$(grep blocs cpio.log | cut -d' ' -f1)
   if [ "$BLOCS" != "" ]
   then
     echo "Blocs : $BLOCS"
     dd if=initramfs2 skip=$BLOCS of=initramfs3 || exit 1
     # List
     cpio -tvF initramfs3 1>/dev/null 2>cpio.log
     BLOCS=$(grep blocs cpio.log | cut -d' ' -f1)
     dd if=initramfs3 skip=$BLOCS of=initramfs4 || exit 1

     zstdcat initramfs4  > initramfs5

     # Details
     echo "details (microcode) : cpio -tvF $PWD/initramfs2"
     echo "details (modules): cpio -tvF $PWD/initramfs3"
     echo "details (init scripts) : cpio -tvF $PWD/initramfs5"
     install -d initramfs-dir

     cd initramfs-dir
     echo "Extract cpio -ivF ../initramfs5" 
     cpio -ivF ../initramfs5 1>/dev/null 2>/dev/null

     echo "Extract cpio -ivF ../initramfs3" 
     cpio -ivF ../initramfs3 1>/dev/null 2>/dev/null

     echo "Files uncompressed at $PWD"
     echo "Write new one with this command :"
     echo 'find . -print |  grep -v '.svn' | cpio -o -H newc -F $PWD/../dev-initramfs.cpio'
     mv init init-original
     echo "#!/bin/sh" > init
     echo "/bin/busybox echo Hacked" >> init
     echo "/bin/busybox sleep 10" >> init
     cat init-original >> init
     chmod +x init
     find . -print |  grep -v '.svn' | cpio -o -H newc -F $PWD/../dev-initramfs.cpio
     echo "Test it with : "
     echo qemu-system-x86_64  -m size=2000 -kernel \"$initramfsdir/vmlinuz\"  -initrd $PWD/../dev-initramfs.cpio  -append \"boot=casper quiet\" -cdrom $1
   fi
   break
done
