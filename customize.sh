SKIPUNZIP=0

REPLACE="
"

. "$MODPATH/config.conf"
set_perm "$MODPATH/bin/ruri" 0 0 0700
set_perm "$MODPATH/bin/*" 0 0 0700
set_perm "$MODPATH/bin/rurima" 0 0 0700
set_perm "$MODPATH/bin/curl" 0 0 0700
set_perm "$MODPATH/bin/file" 0 0 0700
set_perm "$MODPATH/bin/file-static" 0 0 0700
set_perm "$MODPATH/bin/gzip" 0 0 0700
set_perm "$MODPATH/bin/tar" 0 0 0700
set_perm "$MODPATH/bin/xz" 0 0 0700
export PATH="$MODPATH/bin:$PATH"
# 以下自定义安装命令中 Busybox部分不是必须的
link_busybox() {
    local busybox_file=""

    if [ -f "$MODPATH/bin/busybox" ]; then
        busybox_file="$MODPATH/bin/busybox"
    else
        for path in $BUSYBOX_PATHS; do
            if [ -f "$path" ]; then
                busybox_file="$path"
                break
            fi
        done
    fi

    if [ -n "$busybox_file" ]; then
        mkdir -p "$MODPATH/bin"
        # ln -s "$busybox_file" "$MODPATH/bin/busybox_link" #【busybox_link ls】这种使用方法麻烦 故不作推荐
        # 针对特定命令创建符号链接指向找到的busybox文件
        for cmd in fuser timeout; do
            ln -s "$busybox_file" "$MODPATH/bin/$cmd"
        done
    else
        abort "- 未找到可用的 Busybox 文件，请检查你的安装环境"
    fi
}

inotifyfile() {
    id_value=$(sed -n 's/^id=\(.*\)$/\1/p' "$MODPATH/module.prop")
    sed -i "2c MODULEID=\"$id_value\"" "$MODPATH/Ruri_service.sh"

    mv -f "$MODPATH/Ruri_service.sh" "$SERVICEDIR"
}

check_config() {
    [ -z "${BOOTMODE}" ] && abort "- 未处于开机状态, 请启动设备后从 App 中尝试安装"

    export PATH="$MODPATH/bin:$PATH"
    ruri -U "$CONTAINER_DIR"
    inotifyfile
}

automatic() {
    if [[ -e $CONTAINER_DIR/usr ]]; then
        ui_print "- Already installed"
        return
    fi
    chmod 777 $MODPATH/bin/*
    ui_print "- 需联网下载根文件系统 尽量连接wifi后安装~"
    ui_print "- 使用源${RURIMA_LXC_MIRROR}下载根文件系统..."
    set_perm "$MODPATH/bin/ruri" 0 0 0700
    set_perm "$MODPATH/bin/*" 0 0 0700
    set_perm "$MODPATH/bin/rurima" 0 0 0700
    set_perm "$MODPATH/bin/curl" 0 0 0700
    set_perm "$MODPATH/bin/file" 0 0 0700
    set_perm "$MODPATH/bin/file-static" 0 0 0700
    set_perm "$MODPATH/bin/gzip" 0 0 0700
    set_perm "$MODPATH/bin/tar" 0 0 0700
    set_perm "$MODPATH/bin/xz" 0 0 0700
    ruri -U "$CONTAINER_DIR"
    rm -rf "$CONTAINER_DIR"
    rurima lxc pull -n -m ${RURIMA_LXC_MIRROR} -o ${RURIMA_LXC_OS} -v ${RURIMA_LXC_OS_VERSION} -s "$CONTAINER_DIR"
    ui_print "- 启动 chroot 环境执行自动化安装..."
    ui_print "- 请确保网络环境无任何异常 过程可能比较久请耐心等待!"
    ui_print ""
    sleep 3
    echo "$HOSTNAME" >"$CONTAINER_DIR/etc/hostname"
    mkdir "$CONTAINER_DIR"/tmp >/dev/null 2>&1
    cp "$MODPATH/setup/${RURIMA_LXC_OS}.sh" "$CONTAINER_DIR"/tmp/setup.sh
    chmod 777 "$CONTAINER_DIR"/tmp/setup.sh
    sed -i "s/USER=\"\"/USER=\"$USER\"/g" "$CONTAINER_DIR"/tmp/setup.sh
    sed -i "s/PASSWORD=\"\"/PASSWORD=\"$PASSWORD\"/g" "$CONTAINER_DIR"/tmp/setup.sh
    ruri "$CONTAINER_DIR" /bin/sh /tmp/setup.sh
    #rm "$CONTAINER_DIR"/tmp/setup.sh
    ui_print "- 自动化安装完成!"
    ui_print "- 注意： 请修改默认密码，暴露非密钥认证而是密码认证的ssh端口无论何时都是高危行为！"
}

main() {
    link_busybox
    check_config
    automatic
    ruri -U "$CONTAINER_DIR"
}

main
set_perm "$SERVICEDIR/Ruri_service.sh" 0 0 0700
set_perm "$MODPATH/bin/ruri" 0 0 0700
set_perm "$MODPATH/start.sh" 0 0 0700
set_perm "$MODPATH/stop.sh" 0 0 0700
