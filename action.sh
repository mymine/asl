MODDIR=${0%/*}
PORT=$(sed -n 's/^PORT="\([^"]*\)"/\1/p' "$MODDIR/config.conf")
PID=$($MODDIR/bin/fuser "$PORT/tcp" 2>/dev/null)

if [ -n "$PID" ]; then
    printf "- Stopping container...\n\n"
    "$MODDIR"/container_ctrl.sh stop
    sed -i 's|^description=.*|description=\[ stopped🙁 \] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
else
    printf "- Starting up container...\n\n"
    "$MODDIR"/container_ctrl.sh start
    sed -i 's|^description=.*|description=\[ running😉 \] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
fi

countdown=5
while [ $countdown -gt 0 ]; do
    printf "\r- %d" "$countdown"
    sleep 1
    countdown=$((countdown - 1))
done
