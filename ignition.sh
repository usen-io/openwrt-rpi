#!/bin/sh

# ------------------------- STARTING SCRIPT

WORKDIR=/etc/config

# -----------------------------------------

mkdir $WORKDIR/_backup/

cp $WORKDIR/network $WORKDIR/_backup/
cp $WORKDIR/wireless $WORKDIR/_backup/
cp $WORKDIR/firewall $WORKDIR/_backup/

# -----------------------------------------

#  Packages

# confirm internet access
ping -c 3 google.com

#update piackage list
opkg update

# install essentials
opkg install luci-ssl openssh-sftp-server htop vim-full tree diffutils usbutils lsblk fdisk sudo shadow-useradd block-mount fail2ban

# install wireguard packages
opkg install luci-app-wireguard luci-proto-wireguard

# install external interface drivers
opkg install kmod-mt76x2u

## --------------- extras rare case used
#    #install external interface drivers
#    opkg install \
#      kmod-usb-core \
#      kmod-usb-uhci \
#      kmod-usb-ohci \
#      kmod-usb2
## ---------------

# Enable LuCI HTTPS redirect from HTTP

uci set uhttpd.main.redirect_https=1
uci commit uhttpd
service uhttpd reload

# sync and reboot
sync; sync

# reboot
reboot
