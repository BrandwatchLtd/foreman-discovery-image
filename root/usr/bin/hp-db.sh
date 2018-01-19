#!/bin/bash
#port=$( hpssacli ctrl slot=0 pd all show | grep physicaldrive | head -n1 | awk {'print $2'} | cut -d ':' -f1 )
#hpssacli ctrl slot=0 create type=ld drives=${port}:1:3,${port}:1:4 raid=1
#hpssacli ctrl slot=0 create type=ld drives=${port}:1:1,${port}:1:2 raid=1
#hpssacli ctrl slot=0 create type=ld drives=${port}:1:5,${port}:1:6 raid=1
#hpssacli ctrl slot=0 create type=ld drives=${port}:1:7,${port}:1:8 raid=1
#hpssacli ctrl slot=0 create type=ld drives=${port}:1:9,${port}:1:10,${port}:1:11,${port}:1:12 raid=1+0 stripsize=16

parted -a optimal -s /dev/sde mklabel gpt
parted -a optimal -s /dev/sde mkpart primary 0% 100%
parted -a optimal -s /dev/sdb mklabel gpt
parted -a optimal -s /dev/sdb mkpart primary 0% 100%
parted -a optimal -s /dev/sdc mklabel gpt
parted -a optimal -s /dev/sdc mkpart primary 0% 100%
parted -a optimal -s /dev/sdd mklabel gpt
parted -a optimal -s /dev/sdd mkpart primary 0% 100%
parted -a optimal -s /dev/sde set 1 lvm on
parted -a optimal -s /dev/sdb set 1 lvm on
parted -a optimal -s /dev/sdd set 1 lvm on
parted -a optimal -s /dev/sdc set 1 lvm on
pvcreate -ff -y /dev/sde1
pvcreate -ff -y /dev/sdb1
pvcreate -ff -y /dev/sdd1
pvcreate -ff -y /dev/sdc1
vgextend main /dev/sde1 /dev/sdb1 /dev/sdd1 /dev/sdc1
vgchange -a y main
lvcreate -n pg_log -L 30720 main /dev/sda3
mkfs.xfs -f /dev/main/pg_log
lvcreate -n pg_xlog -L 409600 main /dev/sdb1
mkfs.xfs -f /dev/main/pg_xlog
lvcreate -n pg_archive -L 921600 main /dev/sdc1
mkfs.xfs -f /dev/main/pg_archive
lvcreate -n pg_dump -L 921600 main /dev/sdd1
mkfs.xfs -f /dev/main/pg_dump
lvcreate -n pg_ts4 -L 921600 main /dev/sde1
mkfs.xfs -f /dev/main/pg_ts4

apt-get install -y iomemory-vsl-3.16.0-0.bpo.4-amd64 iomemory-vsl-config-3.16.0-0.bpo.4-amd64 iomemory-vsl-source=3.2.10.1509-1.0 fio-common=3.2.10.1509-1.0 fio-sysvinit=3.2.10.1509-1.0 fio-util=3.2.10.1509-1.0 libvsl=3.2.10.1509-1.0 fio-preinstall=3.2.10.1509-1.0 fio-firmware-fusion=3.2.10.20150212-1
fio-update-iodrive -y /usr/share/fio/firmware/fusion_3.2.10-20150212.fff
# REBOOT
sed -i 's/#ENABLED=1/ENABLED=1/' /etc/sysconfig/iomemory-vsl
sed -i 's/LVM_VGS=""/LVM_VGS="\/dev\/nand"/' /etc/sysconfig/iomemory-vsl
sed -i 's/MOUNTS=""/MOUNTS="\/data\/pg_ts1 \/data\/pg_ts2 \/data\/pg_ts3"/' /etc/sysconfig/iomemory-vsl
echo -e "# To keep ioDrive from auto loading at boot when using udev, uncomment below\nblacklist iomemory-vsl" > /etc/modprobe.d/iomemory-vsl.conf

for fio_dev in $( ls -1 /dev/fct? ); do
  fio-detach $fio_dev
  fio-format -y -b 4k $fio_dev
  fio-attach $fio_dev
done

parted -a optimal -s /dev/fioa mklabel gpt
parted -a optimal -s /dev/fioa mkpart primary 0% 100%
parted -a optimal -s /dev/fiob mklabel gpt
parted -a optimal -s /dev/fiob mkpart primary 0% 100%
parted -a optimal -s /dev/fioc mklabel gpt
parted -a optimal -s /dev/fioc mkpart primary 0% 100%
pvcreate -ff -y /dev/fioa1
pvcreate -ff -y /dev/fiob1
pvcreate -ff -y /dev/fioc1
vgcreate nand /dev/fioa1 /dev/fiob1 /dev/fioc1
vgchange -a y nand
lvcreate -n pg_ts1 -L 1500G nand /dev/fioa1
mkfs.xfs -f /dev/nand/pg_ts1
lvcreate -n pg_ts2 -L 1500G nand /dev/fiob1
mkfs.xfs -f /dev/nand/pg_ts2
lvcreate -n pg_ts3 -L 1500G nand /dev/fioc1
mkfs.xfs -f /dev/nand/pg_ts3

mkdir -p /data/{pg_ts4,pg_archive,pg_dump,pg_log,pg_xlog,pg_ts1,pg_ts2,pg_ts3}

echo "/dev/mapper/main-pg_ts4          /data/pg_ts4     xfs  noatime,nodiratime,allocsize=64k 0 2" >> /etc/fstab
echo "/dev/mapper/main-pg_archive      /data/pg_archive xfs  noatime,nodiratime,allocsize=64k 0 2" >> /etc/fstab
echo "/dev/mapper/main-pg_dump         /data/pg_dump    xfs  noatime,nodiratime,allocsize=64k 0 2" >> /etc/fstab
echo "/dev/mapper/main-pg_log          /data/pg_log     xfs  defaults 0 2" >> /etc/fstab
echo "/dev/mapper/main-pg_xlog         /data/pg_xlog    xfs  noatime,nodiratime,allocsize=64k 0 2" >> /etc/fstab
echo "# FIO /etc/sysconfig/iomemory-vsl handles mounting of nand devices" >> /etc/fstab
echo "/dev/mapper/nand-pg_ts1          /data/pg_ts1     xfs  noatime,nodiratime,allocsize=64k,noauto 0 0" >> /etc/fstab
echo "/dev/mapper/nand-pg_ts2          /data/pg_ts2     xfs  noatime,nodiratime,allocsize=64k,noauto 0 0" >> /etc/fstab
echo "/dev/mapper/nand-pg_ts3          /data/pg_ts3     xfs  noatime,nodiratime,allocsize=64k,noauto 0 0" >> /etc/fstab
# REBOOT AGAIN
