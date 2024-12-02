#!/bin/sh
MODDIR=${0%/*}
export PATH="$MODDIR/bin:$PATH"
. "$MODDIR"/config.conf

ruriumount() {
    fuser -k "$CONTAINER_DIR"
    ruri -U "$CONTAINER_DIR"
}

ruriumount
echo "It's done."
