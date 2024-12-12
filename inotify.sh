#!/bin/sh
MODULEID="moduleid"
MODULEDIR="/data/adb/modules/$MODULEID"
DESCRIPTION="Android Subsystem for GNU/Linux Powered by ruri"

if command -v magisk >/dev/null 2>&1; then
    if magisk -v | grep -q lite; then
        MODULEDIR="/data/adb/lite_modules/$MODULEID"
    fi
fi

export PATH="$MODULEDIR/bin:$PATH"

while [ $(getprop sys.boot_completed) != 1 ]; do
    sleep 2
done

[ ! -f "$MODULEDIR"/disable ] && "$MODULEDIR/container_ctrl.sh" start

(
    inotifyd - "$MODULEDIR" 2>/dev/null | while read -r events _ file; do
        if [ "$file" = "disable" ]; then
            case "$events" in
                d)
                    "$MODULEDIR/container_ctrl.sh" start
                    sed -i "6c description=[ on ] $DESCRIPTION" "$MODULEDIR/module.prop"
                    ;;
                n)
                    "$MODULEDIR/container_ctrl.sh" stop
                    sed -i "6c description=[ off ] $DESCRIPTION" "$MODULEDIR/module.prop"
                    ;;
                *)
                    :
                    ;;
            esac
        fi
    done
) &
pid=$!

sed -i "6c description=[ PID=$pid ] This container can be quickly controlled by enabling/disabling" "$MODULEDIR/module.prop"