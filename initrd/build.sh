[ -e initd ] && rm initrd
dd if=/dev/zero of=initrd bs=1M count=100
/sbin/mkfs.ext2 initrd
sudo mount initrd /mnt || exit 1
sudo install -d /mnt/dev
sudo sh $HOME/2.12/ydfs/src/busybox-1.36.1/examples/bootfloppy/mkdevs.sh /mnt/dev || exit $?
sudo sh ../2.12/scripts/make_devs /mnt/dev || exit $?
sudo cp -a /home/yann/2.12/ydfs/tmp/initramfs-x86_64/* /mnt/
sudo umount /mnt
