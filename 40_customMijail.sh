#!/bin/sh
mkdir /boot-isos
chmod 0777 /boot-isos
cd /boot-isos
wget http://148.204.57.203/administracion/isos/180117raizo.iso 

echo menuentry \"RAIZO2\" { >>/etc/grub.d/40_custom
echo insmod iso9660 >>/etc/grub.d/40_custom
echo set isofile=\"/boot-isos/180117raizo.iso\" >>/etc/grub.d/40_custom
echo loopback loop \(hd1,6\)\$isofile >>/etc/grub.d/40_custom
echo linux \(loop\)/live/vmlinuz locales=es_ES.UTF-8 keyboard-layouts=es boot=live union=overlay components noconfig=sudo username=user hostname=raizo user-fullname=Live-Raizo-User findiso=\$isofile debug --verbose nomodeset ip=frommedia >>/etc/grub.d/40_custom
echo initrd \(loop\)/live/initrd.img >>/etc/grub.d/40_custom
echo } >>/etc/grub.d/40_custom

update-grub


