mkdir /tmp/rootfs;
ls -id /tmp/rootfs;    # Show inode number of new root directory
cp $(which busybox) /tmp/rootfs;
PS1='bbsh$ ' sudo ./pivot_root_demo /tmp/rootfs /busybox sh;
