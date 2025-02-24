# Lichee Pi Nano bootable Linux image using mainline kernel

This is a bootable image creation environment that runs on the Lichee Pi Nano, a tiny single-board computer the size of an SD card. Buildroot 2024.02 is used to create the image.

This repository contains all the necessary files to create bootable image, such as Buildroot configuration files for Lichee Pi Nano, Docker virtual build environment configuration files, and shell scripts that gether the related commands. This allows you to create a bootable microSD card image almost completely automatically.

As USB Gadget Ethernet(g_ether) is enabled in the Linux kernel settings, allowing Lichee Pi Nano to connect to internet via the host PC. In other words, with a single USB cable, you can turn Lichee Pi Nano into a tiny internet terminal, allowing you to log in via ssh to debug or run network applications.

## Requirements

- Docker installed PC(tested only on Linux hosts, not Mac or Windows)
   - If the system storage is HDD, build will be very slow. Systems with SSD is recommeended.
- microSD card of 256MB or more
- Lichee Pi Nano board

## Installing build environment

There are two steps below to create environment on a Linux host.

1. Clone this repository
```sh
git clone https://github.com/goediy/licheepi-nano-mainline.git
cd licheepi-nano-mainline
```
2. Building Docker environment
```sh
cd docker/
./00create-docker.sh
```
   Or on bash shell,
```sh
cd docker/
docker build -t br-build:latest --build-arg UID=$UID --build-arg USERNAME=$USER -f Dockerfile .
```

## Creating bootable microSD

Creating bootable microSD card also can be done in just 2 steps.

1. Download and build Buildroot(runs inside Docker container)
```sh
./download-and-build.sh
```
   Or on bash shell,
```sh
docker run --ipc=host --rm -it -v $PWD/:/home/$USER/work br-build /home/$USER/br-build.sh
```

2. Writing bootable image to microSD card
```sh
dd if=sdcard.img of=/dev/sd?
```

## How to log in to Lichee Pi Nano

Lichee Pi Nano can be boot by inserting the bootable microSD card and turning power on. Available login users are shown in the table below.

|username|password|
|:--:|:--:|
|root||
|lichee|pi|

The "lichee" user can be logged in not only from UART0 but also from host PC via network using ssh.

## Network settings for USB Gadget Ethernet

#### usb0 network settings of Lichee Pi Nano

By default, the IP address of USB Ethernet device named usb0 is set to 192.168.10.10/24 and nameserver is set to 192.168.1.1. Change the settings of /etc/network/interfaces and /etc/resolve.conf according to your LAN environment.

#### network settings of host PC

The Ethernet device named usbN(N is number) on host PC must set an IP address of same network as of the Lichee Pi Nano. Also, in order to properly handle IP packets on the Lichee Pi Nano, the host PC must have NAT functionality.

An example of the setup procedure on a Linux host PC is shown below.

- Set IP address with Network Manager
```sh
nmcli connection add type ethernet ifname usb0 con-name usbeth0
nmcli connection mod usbeth0 ipv4.method manual ipv4.addresses 192.168.10.1/24
sudo nmcli connection up usbeth0
```
- Add IP forwarding configuration line into /etc/sysctl.conf
```
net.ipv4.ip_forward=1
```
- Enabling IP forwarding settings
```sh
sudo sysctl -p
```
- Enabling NAT with iptables
```sh
sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i usb0 -o eth0 -j ACCEPT
```
- Persisting iptables settings
```sh
sudo netfilter-persistent save
```

## Buildroot customization steps

To perform customization such as adding packages, run download-and-build.sh one more than once and work inside the Docker container with the Buildroot tarball expanded.

1. Starting Docker container
```sh
./start-docker.sh
```
   Or on bash shell,
```sh
docker run --ipc=host --rm -it -v $PWD/:/home/$USER/work br-build /usr/bin/bash
```
2. Buildroot customization and building (in the Docker container)
```sh
cd work/buildroot-2023.02.4
make menuconfig
make
```

There is an article in my blog about how to customize Buildroot(in Japanese), which might help you.

https://blog.goediy.com/?p=1562

## Enabling swap

F1C100s has only 32MB for internal RAM, and in order to increase memory space as possible, there is a way to use microSD storage area as swap. To enable swap, log in to Lichee Pi Nano and run the following command just once. (requires root privileges)

```sh
sudo mkswap /dev/mmcblk0p3
```

## Running Python sample program

The sample code is a simple one that just displays system time on a 1602 display connected to I2C. For details on how to run it, refer to /opt/example/readme.txt in Lichee Pi Nano's file system. If the network settings are properly configured, Lichee Pi Nano's system clock should be synchronized with the Internet time server using chrony, and the accurate time should be displayed.

![Photo](LicheePiNanoLCDclock.jpg)

## Versions


[Official USB support for the F1C100s begins with version 6.4](https://linux-sunxi.org/Linux_mainlining_effort), and U-Boot support for the F1C100s is from 2023.07.02 onwards.

In Buildroot 2024.02, the LTS kernel 6.6 is selected by default, and U-Boot 2024.01 is also selected, making it compatible with the F1C100s without any custom settings.

As shown in the table below, previously published environments have been kept with tags, so please use them as necessary.

|Tag|Buildroot|Linux|U-Boot|
|:--:|:--:|:--:|:--:|
|v6.6_br2024.02|2024.02.9|6.6.63|2024.01|
|[v6.4.16_br2023.02](https://github.com/goediy/licheepi-nano-mainline/tree/v6.4.16_br2023.02)|2023.02.4|6.4.16|2023.07.02|


## Projects referenced

unframework's Lichee Pi Nano project with attractive features such as a working color LCD display influenced me how to create a Buildroot external configuration file. I actually used this project to generate bootable images before.

https://github.com/unframework/licheepi-nano-buildroot

## ToDo

- I2C, GPIO, USB Gadget Ethernet and USB host operation seem to be basically fine. However, if USB host operation is via USB hub, the USB device will behave strangely.
- Operation of SPI has not been confirmed. Supporting "spidev" is needed to use SPI in Python, but I don't know how to set it up. (Can someone please help me?)
- Onboard SPI flash is recognized as /dev/mtd0 and looks like fine, but I don't know how to write to it bootable image, so it is not supported at the moment.
