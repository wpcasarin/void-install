#!/bin/sh

HOST=void

echo "Configuring system"
echo $HOST > /etc/hostname
echo "permit persist :wheel" > /etc/doas.conf
echo -e "session\t\toptional\tpam_rundir.so" | tee -a /etc/pam.d/login 
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime   
ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps-except-emoji.conf /etc/fonts/conf.d/
ln -sf /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
rm /etc/fonts/conf.d/10-sub-pixel-none.conf

mkdir -p /etc/profile.d
echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=38"' > /etc/profile.d/freetype2.sh

sed -i '/CGROUP_MODE/c\CGROUP_MODE=unified' /etc/rc.conf
sed -i '/HARDWARECLOCK/c\HARDWARECLOCK="UTC"' /etc/rc.conf

ln -s /etc/sv/acpid /var/service
ln -s /etc/sv/seatd /var/service
ln -s /etc/sv/dbus /var/service

xbps-alternatives -s booster
xbps-reconfigure -fa

KERNEL_VERSION=$(basename /boot/vmlinuz-* | sed 's/vmlinuz-//')

if [ -z "$KERNEL_VERSION" ] || [ "$KERNEL_VERSION" = "*" ]; then
    echo "Error: Failed to extract kernel version"
    exit 1
fi
echo "Detected kernel version: $KERNEL_VERSION"

efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Void Linux $KERNEL_VERSION" --loader /vmlinuz-$KERNEL_VERSION --unicode "root=LABEL=VOID rw quiet initrd=\\initramfs-$KERNEL_VERSION.img"

echo "Enter root password."
passwd root

echo "Enter $USER passwod."
useradd -m -G wheel,audio,video,_seatd -s /bin/bash $USER
passwd $USER
