#https://man7.org/linux/man-pages/man2/pivot_root.2.html
cp pivot_root_demo /tmp
chmod +x /tmp/pivot_root_demo 
mkdir /tmp/rootfs;
#gcc pivot_root_demo.c -o pivot_root_demo
ls -id /tmp/rootfs;    # Show inode number of new root directory
cp $(which busybox) /tmp/rootfs;
PS1='bbsh$ ' sudo /tmp/pivot_root_demo /tmp/rootfs /busybox sh;
