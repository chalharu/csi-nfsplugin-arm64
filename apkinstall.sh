#!/qemu-aarch64-static /bin/sh

/qemu-aarch64-static /bin/busybox mv /bin/sh /bin/sh.orig

/qemu-aarch64-static /bin/busybox echo "#!/qemu-aarch64-static /bin/sh.orig" > /bin/sh
/qemu-aarch64-static /bin/busybox echo "/qemu-aarch64-static /bin/sh.orig $@" >> /bin/sh
/qemu-aarch64-static /bin/busybox chmod a+x /bin/sh

/qemu-aarch64-static /bin/busybox mv /bin/busybox /bin/busybox.orig

/qemu-aarch64-static /bin/busybox.orig echo "#!/qemu-aarch64-static /bin/sh" > /bin/busybox
/qemu-aarch64-static /bin/busybox.orig echo "/qemu-aarch64-static /bin/busybox.orig $0 $@" >> /bin/busybox
/qemu-aarch64-static /bin/busybox.orig chmod a+x /bin/busybox

/qemu-aarch64-static /sbin/apk --no-cache add nfs-utils jq

mv /bin/sh.orig /bin/sh
mv /bin/busybox.orig /bin/busybox
