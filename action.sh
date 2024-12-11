#!/bin/sh
MODDIR=${0%/*}
if grep -q "status=running" "$MODDIR/module.prop"; then
    STATUS="running"
else
    STATUS="stopped"
fi
if [ "$STATUS" = "stopped" ]; then
    "$MODDIR"/start.sh
    sed -i 's|\[.*\]|[status=running]|' "$MODDIR/module.prop"
else
    "$MODDIR"/stop.sh
    sed -i 's|\[.*\]|[status=stopped]|' "$MODDIR/module.prop"
fi
