#!/bin/sh

for pid in $(pgrep -f "statusbar-deamon.py"); do
	eval $(grep -z "^USER" "/proc/${pid}/environ")
	su ${USER} -c "/home/${USER}/bin/statusbar-scheduler.py $1"
done
