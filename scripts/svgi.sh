#!/bin/bash

#this is the grub file that will be edited
grubd=40_custom
#/>

#update the preexisting mementry in 40_custom
cp /etc/grub.d/$grubd /home/camille/.cache/$grubd
varcurrentlinux=$(ls -1 /boot/vmlinuz-* | awk -F '-' '{print $2}' | sort -V | tail -n 1)
echo "Latest kernel found : $varcurrentlinux"
sed -i "s/[0-9]\.[0-9]\.[0-9]*_[0-9]/$varcurrentlinux/g" /etc/grub.d/40_custom
update-grub

#update the no-vfio.img using dracut
mv /etc/dracut.conf.d/20-vfio.conf /etc/
dracut --force /boot/no-vfio.img
#move back 20-vfio.conf into /etc/dracut.conf.d/
mv /etc/20-vfio.conf /etc/dracut.conf.d/

