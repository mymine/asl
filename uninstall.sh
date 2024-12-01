#!/bin/sh
MODDIR=${0%/*}
"$MODDIR/stop.sh"
sleep 3
. "$MODDIR/config.conf"
rm -f "$SERVICEDIR/Ruri_service.sh"
rm -rf "$CONTAINER_DIR"
