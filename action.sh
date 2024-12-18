MODDIR=${0%/*}
PORT=$(sed -n 's/^PORT=\(.*\)/\1/p' "$MODDIR/config.conf")
PID=$("$MODDIR/bin/fuser" "$PORT/tcp" 2>/dev/null)

BETA() {
    local PREFIX=/data/user/0/com.termux/files/usr
    local TBIN=$PREFIX/bin
    local BASH=$TBIN/bash
    local TMPDIR=$PREFIX/tmp
    local BATE=$TMPDIR/asl.sh

    if [ ! -d "$PREFIX" ]; then
        echo "- TThe environment of Termux is abnormal"
        return
    fi

    cp -f "$MODDIR/bate.sh" "$BATE"
    chmod 755 "$BATE"

    echo "- It will run in Termux soon. Please make sure the network is working properly"
    echo "- Check whether Termux is running in the background"
    echo "！Friendly reminder: If it doesn't jump to the Termux page, please pull down the notification bar and click on Termux to enter the Termux application"

    pidof com.termux &>/dev/null
    if [[ $? = 0 ]]; then
        echo "- It's already running"
        sleep 3
    else
        echo "- Opening Termux"
        sleep 1
        $TBIN/am start -n com.termux/com.termux.app.TermuxActivity >/dev/null
        sleep 3
        pidof com.termux &>/dev/null || echo "！Failed to open the Termux app. Please open it manually"
    fi

    $TBIN/am startservice \
        -n com.termux/com.termux.app.TermuxService \
        -a com.termux.service_execute \
        -d com.termux.file:$BATE \
        -e com.termux.execute.background true >/dev/null

    echo "- Waiting for Termux to finish installing..."
}

update_ssh() {
    local rootfs="/data/$(sed -n 's/^RURIMA_LXC_OS="\([^"]*\)"/\1/p' "$MODDIR/config.conf")"

    sleep 2
    if lsof | grep "$rootfs" | awk '{print $2}' | uniq | grep -q "sshd"; then
        sed -i 's|^description=.*|description=\[ running😉 \] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
    else
        sed -i 's|^description=.*|description=\[ running⚠️ \] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"
    fi
}

if [ -n "$PID" ]; then
    printf "- Stopping container...\n\n"
    "$MODDIR/container_ctrl.sh" stop
    sed -i 's|^description=.*|description=\[ stopped🙁 \] Android Subsystem for GNU/Linux Powered by ruri|' "$MODDIR/module.prop"

    BETA
else
    printf "- Starting up container...\n\n"
    "$MODDIR/container_ctrl.sh" start

    update_ssh
fi

countdown=3
while [ $countdown -gt 0 ]; do
    printf "\r- %d" "$countdown"
    sleep 1
    countdown=$((countdown - 1))
done
