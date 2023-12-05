#!/system/bin/sh

path="/data/adb/gh_sing-box"
service="${path}/service/service.sh"

events="$1"
monitor_dir="$2"
monitor_file="$3"

if [ "${monitor_file}" = "disable" ]; then
  if [ "${events}" = "d" ]; then
    sleep 1
    "${service}" start
  elif [ "${events}" = "n" ]; then
    "${service}" stop
  fi
fi
