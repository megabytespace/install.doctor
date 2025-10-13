#!/bin/bash

/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --setglobaldescription "." --getglobalstate
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32400 --protocol tcp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 1900 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32469 --protocol tcp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32410 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32412 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32413 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --port 32414 --protocol udp
