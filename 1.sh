

rm -r os

mkdir -p os/initramfs
cp -r -L linux-7.0/arch/x86_64/boot/bzImage os

cp -r busybox-1.38.0/_install/* os/initramfs

rm os/initramfs/linuxrc



cd os/initramfs

mkdir -p dev proc sys tmp

cd dev

mknod tty1 c 4 1
mknod tty2 c 4 2
mknod tty3 c 4 3
mknod tty4 c 4 4
mknod console c 5 1
mknod null c 1 3

cd ..

cat >> init << EOF
#!/bin/bash

# 1. 创建必要的目录


# 2. 挂载伪文件系统
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys


# 3. 启动 bash（指定在哪个终端上运行）
/bin/bash
EOF


chmod -x  init



find . | cpio -o -H newc > ../init.cpio
cd ..
dd if=/dev/zero of=boot  bs=1M count=50

mkfs -t fat boot
syslinux boot



mkdir m
mount boot m
ls
sudo cp -r -L  bzImage init.cpio m
umount m
rm -r m

ls

qemu-system-x86_64 -kernel bzImage -initrd init.cpio -m 2G
