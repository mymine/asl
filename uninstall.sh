#!/bin/sh
MODDIR=${0%/*}
"$MODDIR"/stop.sh
sleep 3
. "$MODDIR"/config.conf
rm -f /data/adb/service.d/inotify.sh
rm -rf "$CONTAINER_DIR"
rm -rf "$CONTAINER_DIR.old"
version=1
while [ -d "$CONTAINER_DIR.old.$version" ]; do
    rm -rf "$CONTAINER_DIR.old.$version"
    version=$((version + 1))
done
