#!/system/bin/sh

moddir=/data/adb/modules/gh_sing-box
path="/data/adb/gh_sing-box"
log_path="${path}/logs"
service_path="${path}/service"

start() {
  rm -f ${log_path}/service.log
  if [[ -f "${path}/config.txt" ]];then
    source "${path}/config.txt"
    if [[ -n "$sub" ]]; then
      curl -o "${path}/config.json" ${sub}
    else
      echo "No sing-box sub url" >> ${log_path}/service.log
    fi
  else
    echo "No Ghitori Sing-Box config" >> ${log_path}/service.log
  fi
  nohup ${moddir}/sing-box -D $path run >> ${log_path}/service.log 2>&1 &
}

stop() {
  pid=$(pidof sing-box)
  if [[ -n ${pid} ]];then
    kill -9 ${pid}
  fi
  echo "Sing-Box stopped." >> ${log_path}/service.log
}

case "$1" in
  start)
    stop
    start
    "${service_path}/crond.sh" start
    ;;
  stop)
    stop
    "${service_path}/crond.sh" stop
    ;;
  restart)
    stop
    start
    ;;
esac
