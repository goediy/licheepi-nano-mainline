setenv bootargs console=ttyS0,115200 panic=5 console=tty0 rootwait root=/dev/mmcblk0p2 debug rw
load mmc 0:1 0x80C00000 devicetree.dtb
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
