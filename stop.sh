#!/bin/sh
MODDIR=${0%/*}
export PATH="$MODDIR/bin:$PATH"
. "$MODDIR"/config.conf

ruriumount() {
    fuser -k "$CONTAINER_DIR"
    ruri -U "$CONTAINER_DIR"
    umount -lvf "$CONTAINER_DIR"
    umount -lf "$CONTAINER_DIR"/sdcard
    umount -lf "$CONTAINER_DIR"/sys
    umount -lf "$CONTAINER_DIR"/proc
    umount -lf "$CONTAINER_DIR"/dev
}

ruriumount
echo "It's done."
