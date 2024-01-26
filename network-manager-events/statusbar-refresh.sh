#!/bin/sh

interface=$1
event=$2

WIFI="wlp3s0"
ETH="enp2s0"

if ([ "$interface" != "$WIFI" ] && [ "$interface" != "$ETH" ]) || \
    ([ "$event" != "up" ] && [ "$event" != "down" ]); then
	return 0
fi

request="wifi"
if [ "$interface" = "$ETH" ]; then
    request="eth"
fi

for pid in $(pgrep -f "statusbar-deamon"); do
	eval $(grep -z "^USER" "/proc/${pid}/environ")
	su ${USER} -c "statusbar-scheduler ${request}"
done
return 0
