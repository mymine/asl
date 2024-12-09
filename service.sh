#!/bin/sh
MODDIR=${0%/*}

while [ $(getprop sys.boot_completed) != 1 ]; do
    sleep 2
done

"$MODDIR"/start.sh

if [ -f "$MODDIR/.pidfile" ]; then
    pid=$(cat "$MODDIR/.pidfile")
else
    pid=""
fi

if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
    sed -i "6c description=The container can be started/stopped through the start.sh/stop.sh scripts of the module" "$MODDIR/module.prop"
fi
