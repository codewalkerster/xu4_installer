#!/bin/bash

sudo umount /media/${USER}/fat32
sudo losetup -d /dev/loop0

# make image of loop devices filled zero.
echo "dd if=/dev/zero of=./installer.img count=1024000"
dd if=/dev/zero of=./installer.img count=1024000

# mount loop devices.
echo "sudo losetup /dev/loop0 installer.img"
sudo losetup /dev/loop0 installer.img

# create partition table.
echo "sudo parted /dev/loop0 mktable msdos"
sudo parted /dev/loop0 mktable msdos

# make file-system.
echo "sudo parted /dev/loop0 mkpart primary fat32 90 524"
sudo parted /dev/loop0 mkpart primary fat32 90 524

# format file-system.
echo "sudo mkfs.vfat -F 32 /dev/loop0p1"
sudo mkfs.vfat -F 32 /dev/loop0p1

# fusing u-boot.
echo "pushd uboot"
pushd uboot
echo "./sd_fusing.sh /dev/loop0"
sudo ./sd_fusing.sh /dev/loop0
echo "popd"
popd

# mount user fat partition.
echo "sudo mount /dev/loop0p1 /media/${USER}/fat32/"
sudo mount /dev/loop0p1 /media/${USER}/fat32/

# copy android images and u-boot binaries.
echo "sudo cp update/* /media/${USER}/fat32/"
sudo cp update/* /media/${USER}/fat32/

# eMMC
# copy script for eMMC.
echo "sudo cp emmc/boot.ini /media/${USER}/fat32/"
sudo cp emmc/boot.ini /media/${USER}/fat32/
echo "sudo umount /media/${USER}/fat32"
sleep 3
sudo umount /media/${USER}/fat32
# dump binary
echo "sudo dd if=/dev/loop0 of=emmc/self-emmc.img count=1024000"
sudo dd if=/dev/loop0 of=emmc/self-emmc.img count=1024000

# SD
# copy script for SD.
echo "sudo mount /dev/loop0p1 /media/${USER}/fat32/"
sudo mount /dev/loop0p1 /media/${USER}/fat32/
echo "sudo cp sd/boot.ini /media/${USER}/fat32/"
sudo cp sd/boot.ini /media/${USER}/fat32/
echo "sudo umount /media/${USER}/fat32"
sleep 3
sudo umount /media/${USER}/fat32
# dump binary
echo "sudo dd if=/dev/loop0 of=sd/self-sd.img count=1024000"
sudo dd if=/dev/loop0 of=sd/self-sd.img count=1024000

# SD to eMMC
# copy script for SD to eMMC.
echo "sudo mount /dev/loop0p1 /media/${USER}/fat32/"
sudo mount /dev/loop0p1 /media/${USER}/fat32/
echo "sudo cp sd2emmc/boot.ini /media/${USER}/fat32/"
sudo cp sd2emmc/boot.ini /media/${USER}/fat32/
echo "sudo umount /media/${USER}/fat32"
sleep 3
sudo umount /media/${USER}/fat32
# dump binary
echo "sudo dd if=/dev/loop0 of=sd2emmc/sd2emmc.img count=1024000"
sudo dd if=/dev/loop0 of=sd2emmc/sd2emmc.img count=1024000

# umount loop device.
echo "sudo losetup -d /dev/loop0"
sudo losetup -d /dev/loop0
