#!/bin/sh
MODULEID="id"
MODULEDIR="/data/adb/modules/$MODULEID"

if command -v magisk 2>&1 >/dev/null; then
    if magisk -v | grep -q lite; then
        MODULEDIR="/data/adb/lite_modules/$MODULEID"
    fi
fi

until [ $(getprop sys.boot_completed) -eq 1 ]; do
    sleep 3
done

[ ! -f "$MODULEDIR/disable" ] && "$MODULEDIR/start.sh"

(
    inotifyd - "$MODULEDIR" 2>/dev/null |
        while read events dir file; do
            if [ "$file" = "disable" ]; then
                NOW=$(TZ='Asia/Shanghai' date +"%Y-%m-%d %H:%M:%S %Z")
                case "$events" in
                d)
                    "$MODULEDIR/start.sh"
                    ;;
                n)
                    "$MODULEDIR/stop.sh"
                    ;;
                *)
                    :
                    ;;
                esac
            fi
        done
) &

# while read -r line; do
#     # echo "test line: $line" >> debug.log
#     events=$(echo "$line" | awk '{print $1}')
#     monitor_dir=$(echo "$line" | awk '{print $2}')
#     monitor_file=$(echo "$line" | awk '{print $3}')
#
#     if [ "$monitor_file" = "disable" ]; then
#         case "$events" in
#             d)
#                 su -c "sh $MODULEDIR/start.sh"
#                 ;;
#             n)
#                 su -c "sh $MODULEDIR/stop.sh"
#                 ;;
#             *)
#                 :
#                 ;;
#         esac
#     fi
# done < <(inotifyd - "$MODULEDIR" 2>/dev/null) &
