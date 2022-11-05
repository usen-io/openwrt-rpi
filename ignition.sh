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
opkg install                    \ #
      sudo                      \ # grant privilege escalation
      htop                      \ # get perf. status
      tree                      \ # get direcotry scheme
      lsblk                     \ # get disk and block info
      fdisk                     \ # play with disk
      luci-ssl                  \ # grant and forece https on luci
      fail2ban                  \ # checker
      vim-full                  \ # code editor
      usbutils                  \ # get usb info
      diffutils                 \ # comparations between files and folders
      block-mount               \ # play with disk
      shadow-useradd            \ # play with users
      openssh-sftp-server       \ # remote manage files and folders
      luci-app-advanced-reboot    # andvance luci manager

# install wireguard packages
opkg install
      luci-app-wireguard        \ # wireguard for luci
      luci-proto-wireguard        # wireguard protocol

# install external interface drivers
opkg install kmod-mt76x2u         # kernel modules for MediaTek Inc. Wireless Adapter: Alfa USB Adapter AWUS036ACM

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
