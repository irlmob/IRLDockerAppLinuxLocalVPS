#!/bin/bash

## Clean up
rm -rf /config/templates

## Internal routing. We are exposing port from the local network to the remote HOST
echo ""
echo "🅿️ Apply Internal/External routing -> postup.sh"
echo ""
/etc/wireguard-redir/postup.sh
ps aux | grep redir
echo ""

## Patch Avahi to use our local folder
## This will advertise the host services via Bonjour on the network
echo "🌏 Avahi services -> /config/avahi/services"
echo ""
/etc/init.d/avahi-daemon stop
rm -rf /etc/avahi 
cd /etc/
ln -s /config/avahi .
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
echo ""
cat /config/avahi/services/*
echo ""
echo ""

echo "🖥 Your Machine ${LOCAL_HOSTNAME} should be visible" 
echo " on your local network ${LOCAL_SUBNET} 🚀 !!!"
echo ""
echo "      MAC ADDRESS: ${LOCAL_MAC_ADRESS}"
echo "      HOSTNAME: ${LOCAL_HOSTNAME}"
echo "      IP: ${LOCAL_IPADRESS}"
for p in ${DISTANT_OPEN_PORTS[@]}; do
echo "      OPEN: ${LOCAL_HOSTNAME}.local:${p}  or  ${LOCAL_IPADRESS}:${p} "
done
echo ""
echo "✅ Done"
