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
    sed -i 's|^description=.*|description=\[status=stopped😇\] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
else
    sed -i 's|^description=.*|description=\[status=running😉\] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
fi
