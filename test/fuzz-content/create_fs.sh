#!/bin/bash

set -ux

img_name=fuzzfs.ext4


if [[ -e $img_name ]]; then
    rm $img_name
fi

dd if=/dev/zero of=$img_name bs=4096 count=55
loop_dev=`losetup -f`
sudo losetup -P $loop_dev $img_name
sudo mkfs.ext4 $loop_dev

mountpoint=tmp
if [[ -d $mountpoint ]]; then
    rm -rf $mountpoint
fi

mkdir $mountpoint
sudo mount $loop_dev $mountpoint
sudo chown -R ty:ty $mountpoint

echo "fuzzme" > $mountpoint/fuzzme.txt

sudo umount $mountpoint
sudo losetup -d $loop_dev
rm -rf $mountpoint
