SKIPUNZIP=0

REPLACE="
"
bootinspect() {
    if [ "$BOOTMODE" ] && [ "$KSU" ]; then
        ui_print "- Install from KernelSU"
        ui_print "- KernelSU Version：$KSU_KERNEL_VER_CODE（App）+ $KSU_VER_CODE（ksud）"
    elif [ "$BOOTMODE" ] && [ "$APATCH" ]; then
        ui_print "- Install from APatch"
        ui_print "- Apatch Version：$APATCH_VER_CODE（App）+ $KERNELPATCH_VERSION（KernelPatch）"
    elif [ "$BOOTMODE" ] && [ "$MAGISK_VER_CODE" ]; then
        ui_print "- Install from Magisk"
        ui_print "- Magisk Version：$MAGISK_VER（App）+ $MAGISK_VER_CODE"
    else
        ui_print "- Unsupported installation mode. Please install from the application (Magisk/KernelSu/Apatch)"
    fi
}

link_busybox() {
    local busybox_file=""

    if [ -f "$MODPATH"/bin/busybox ]; then
        busybox_file="$MODPATH"/bin/busybox
    else
        for path in $BUSYBOX_PATHS; do
            if [ -f "$path" ]; then
                busybox_file="$path"
                break
            fi
        done
    fi

    if [ -n "$busybox_file" ]; then
        mkdir -p "$MODPATH"/bin
        # "$busybox_file" --install -s "$MODPATH/bin"
        # This method creates links pointing to all commands of busybox, so it is not recommended. The following is an alternative approach for creating symbolic links pointing to the busybox file for specific commands
        for cmd in fuser; do
            ln -s "$busybox_file" "$MODPATH"/bin/"$cmd"
        done
    else
        abort "- No available Busybox file found Please check your installation environment"
    fi
}

inotifyfile() {
    id_value=$(sed -n 's/^id=\(.*\)$/\1/p' "$MODPATH"/module.prop)
    MONITORFILE=".${id_value}.service.sh"

    sed -i "2c MODULEID=\"$id_value\"" "$MODPATH"/inotify.sh
    mkdir -p /data/adb/service.d
    mv -f "$MODPATH"/inotify.sh /data/adb/service.d/"$MONITORFILE"
    chmod +x /data/adb/service.d/"$MONITORFILE"

    sed -i "s/inotify.sh/$MONITORFILE/g" "$MODPATH"/uninstall.sh
}

configuration() {
    set_perm_recursive $MODPATH 0 0 0755 0755
    . "$MODPATH"/config.conf

    export PATH="$MODPATH/bin:$PATH"
    ruri -U "$CONTAINER_DIR"

    if [[ -e $CONTAINER_DIR/usr ]]; then
        abort "- Already installed"
    fi
}

automatic() {
    ui_print "- A network connection is required to download the root filesystem. Please connect to WiFi before installation whenever possible"
    ui_print "- Downloading the root filesystem using the source ${RURIMA_LXC_MIRROR}..."
    ruri -U "$CONTAINER_DIR"
    rm -rf "$CONTAINER_DIR"
    rurima lxc pull -n -m ${RURIMA_LXC_MIRROR} -o ${RURIMA_LXC_OS} -v ${RURIMA_LXC_OS_VERSION} -s "$CONTAINER_DIR"
    ui_print "- Starting the chroot environment to perform automated installation..."
    ui_print "- Please ensure the network environment is stable. The process may take some time, so please be patient!"
    ui_print ""
    sleep 3
    echo "$HOSTNAME" >"$CONTAINER_DIR"/etc/hostname
    mkdir "$CONTAINER_DIR"/tmp >/dev/null 2>&1
    cp "$MODPATH/setup/${RURIMA_LXC_OS}.sh" "$CONTAINER_DIR"/tmp/setup.sh
    chmod 777 "$CONTAINER_DIR"/tmp/setup.sh
    sed -i "s/USER=\"\"/USER=\"$USER\"/g" "$CONTAINER_DIR"/tmp/setup.sh
    sed -i "s/PASSWORD=\"\"/PASSWORD=\"$PASSWORD\"/g" "$CONTAINER_DIR"/tmp/setup.sh
    sed -i "s/PORT=\"\"/PORT=\"$PORT\"/g" "$CONTAINER_DIR"/tmp/setup.sh
    ruri "$CONTAINER_DIR" /bin/"$SHELL" /tmp/setup.sh

    inotifyfile

    #rm "$CONTAINER_DIR"/tmp/setup.sh
    ui_print "- Automated installation completed!"
    ui_print "- Note: Please change the default password. Exposing an SSH port with password authentication instead of key-based authentication is always a high-risk behavior!"
}

main() {
    bootinspect
    configuration
    link_busybox
    automatic
    ruri -U "$CONTAINER_DIR"
}

main

set_perm "$MODPATH"/bin/ruri 0 0 0700
set_perm "$MODPATH"/start.sh 0 0 0700
set_perm "$MODPATH"/stop.sh 0 0 0700

ui_print "- Please restart the system"
ui_print ""