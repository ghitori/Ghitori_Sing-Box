#!/system/bin/sh

(
    path="/data/adb/gh_sing-box"
    log_path="${path}/logs"
    service_path="${path}/service"
    moddir="/data/adb/modules/gh_sing-box"

    until [ $(getprop init.svc.bootanim) = "stopped" ]; do
        sleep 10
    done

    if [ -f "${service_path}/service.sh" ]; then
        chmod 755 ${service_path}/*
        chmod 755 ${moddir}/sing-box
        if [[ ! -f "${moddir}/disable" ]];then
            "${service_path}/service.sh" start
        fi
        inotifyd "${service_path}/inotify.sh" "${moddir}" >> "/dev/null" 2>&1 &
    else
        echo "Service File Not Found."
    fi
)&