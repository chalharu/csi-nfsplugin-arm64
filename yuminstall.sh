#!/qemu-aarch64-static /bin/sh

/qemu-aarch64-static /sbin/insmod binfmt_misc
/qemu-aarch64-static /sbin/mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
/qemu-aarch64-static /bin/echo ':qemu-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/qemu-aarch64-static:' > /proc/sys/fs/binfmt_misc/register
yum -y install nfs-utils epel-release jq
yum clean all
