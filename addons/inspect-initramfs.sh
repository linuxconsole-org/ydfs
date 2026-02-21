# https://linuxconfig.org/how-to-uncompress-and-list-an-initramfs-content-on-linux
# tested arg /media/yann/FBAF-A120/linuxmint-22.3-xfce-64bit.iso
[ "$1" = "" ] && echo "Needs iso !" && exit 1

mount | grep loop0 || udisksctl loop-setup -f $1 || exit 1

sleep 1

find /media/yann/ -name initrd.lz |while read initramfs
do
   echo $initramfs
   cpio -tvF "$initramfs" 2>cpio.log
   BLOCS=$(grep blocs cpio.log | cut -d' ' -f1)
   echo "Blocs : $BLOCS"
   dd if="$initramfs" skip=$BLOCS of=initramfs2
   cpio -tvF initramfs2 2>cpio.log
   BLOCS=$(grep blocs cpio.log | cut -d' ' -f1)
   echo "Blocs : $BLOCS"
   dd if=initramfs2 skip=$BLOCS of=initramfs3
   # List
   cpio -tvF initramfs3
   # Extract
   # cpio -ivF initramfs3
   break
done
