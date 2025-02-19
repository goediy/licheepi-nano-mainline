#!/bin/sh

BR_RELEASE='2024.02.9'

PACKAGE=buildroot-${BR_RELEASE}.tar.gz
BR_ROOT=buildroot-${BR_RELEASE}

cd ~/work/
if [ ! -e ${PACKAGE} ]; then
    DOWNLOAD_URL=https://buildroot.org/downloads/${PACKAGE}
    echo "Downloading : ${DOWNLOAD_URL}"
    wget -q -c ${DOWNLOAD_URL}
fi
if [ ! -d ${BR_ROOT} ]; then
    echo "Extracting ..."
    tar axf ${PACKAGE}
fi
ln -sf ${BR_ROOT}/output/images/sdcard.img .
cd ${BR_ROOT}
echo "Building ..."
BR2_EXTERNAL=../br-config/ make licheepi_nano_defconfig
make
