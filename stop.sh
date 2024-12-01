#!/bin/sh
MODDIR=${0%/*}
. "$MODDIR/config.conf"

ruriumount() {
    ruri -U "$CONTAINER_DIR"
}

ruriumount
echo "It's done."
