#!/data/data/com.termux/files/usr/bin/sh
# Project PhoenixNix - boot services
termux-wake-lock
sleep 10
. /data/data/com.termux/files/usr/etc/profile.d/start-services.sh
sv up sshd
