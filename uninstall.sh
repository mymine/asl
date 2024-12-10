#!/bin/sh
MODDIR=${0%/*}
"$MODDIR"/stop.sh
sleep 3
. "$MODDIR"/config.conf
rm -f /data/adb/service.d/inotify.sh
umount -lf "$CONTAINER_DIR"/dev
umount -lf "$CONTAINER_DIR"/proc
umount -lf "$CONTAINER_DIR"/sys
umount -lf "$CONTAINER_DIR"/sdcard
rm -rf "$CONTAINER_DIR"
rm -rf "$CONTAINER_DIR".old