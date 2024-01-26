#!/bin/sh

interface=$1
event=$2

if [ "$interface" != "wlp3s0" ] || ([ "$event" != "up" ] && [ "$event" != "down" ]); then
	return 0
fi

for pid in $(pgrep -f "statusbar-deamon.py"); do
	eval $(grep -z "^USER" "/proc/${pid}/environ")
	su ${USER} -c "/home/${USER}/bin/statusbar-scheduler.py wifi"
done
return 0
