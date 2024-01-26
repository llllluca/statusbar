#!/bin/sh

for pid in $(pgrep -f "statusbar-deamon"); do
	eval $(grep -z "^USER" "/proc/${pid}/environ")
	su ${USER} -c "statusbar-scheduler $1"
done
