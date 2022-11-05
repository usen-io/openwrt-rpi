#!/bin/sh

# -------- USAGE 
# -------- ./customize.sh <username> <userpass> <rootpass> <hostname>

USERNAME=$1
USERPASS=$2
ROOTPASS=$3
HOSTNAME=$4

# change root password

printf "${ROOTPASS}\n${ROOTPASS}\n" | passwd root

# -------- create a regular user

useradd -s /bin/ash -N -m ${USERNAME}

printf "${USERPASS}\n${USERPASS}\n" | passwd ${USERNAME}

echo '%users ALL=(ALL) NOPASSWD: ALL' |EDITOR=/usr/bin/tee visudo

mkdir /home/$USERNAME/.ssh && cd /home/$USERNAME/.ssh

cp /etc/dropbear/authorized_keys . && chown ${USERNAME}: *

# -------- disable ssh root login

uci set dropbear.@dropbear[0].PasswordAuth="off"
uci set dropbear.@dropbear[0].RootPasswordAuth="off"
uci set dropbear.@dropbear[0].RootLogin="on"
uci commit dropbear
service dropbear restart

# -------- set the system hostname

uci set system.@system[0].hostname=${HOSTNAME}
uci commit

# -------- reboot
reboot
