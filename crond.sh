#!/system/bin/sh

moddir=/data/adb/modules/sing-box
path="/data/adb/gh_sing-box"
log_path="${path}/logs"
alias crond="/data/adb/magisk/busybox crond"

start() {
  rm -f ${log_path}/cron.log
  if [[ ! -d "${path}/cron" ]];then
    mkdir -p "${path}/cron"
  fi
  if [[ -f "${path}/config.txt" ]];then
    source "${path}/config.txt"
    if [[ -z "${cron}" ]]; then
      echo "No cron scheduling information" >> ${log_path}/cron.log
      exit 1
    fi
    echo "${cron} ${path}/service/service.sh restart" > ${path}/cron/root
    crond -f -c ${path}/cron 2>&1 >> ${log_path}/cron.log &
    pid=$!
    if [[ -n "${pid}" ]];then
      if [[ `ps -p ${pid} -o comm=` == *"busybox"* ]];then
        echo ${pid} > ${path}/cron/crond.pid
        echo "Crond Service started. PID = ${pid}". > ${log_path}/cron.log
      else
        echo "PID(${pid}) is not busybox." > ${log_path}/cron.log
      fi
    else
      echo "Crond Service startup failed."> ${log_path}/cron.log
    fi
    
  else
    echo "No Ghitori Sing-Box config" >> ${log_path}/service.log
  fi
}

stop() {
  if [[ -f ${path}/cron/crond.pid ]];then
    pid=`cat ${path}/cron/crond.pid`
    if [[ -n ${pid} ]];then
      if [[ `ps -p ${pid} -o comm=` == *"busybox"* ]];then
        kill -9 ${pid}
      fi
    fi
    rm -f ${path}/cron/crond.pid
  fi
  echo "Crond Service stopped." > ${log_path}/cron.log
}

case "$1" in
  start)
    stop
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
esac
