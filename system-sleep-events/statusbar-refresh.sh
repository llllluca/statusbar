#!/bin/sh

case "$1" in 
    post) 
        for pid in $(/usr/bin/pgrep -f "statusbar-deamon"); do
            eval $(/usr/bin/grep -z "^USER" "/proc/${pid}/environ")
            /usr/bin/su ${USER} -c "statusbar-scheduler datetime,battery"
        done
    ;;
esac

