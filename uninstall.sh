#!/system/bin/sh

path="/data/adb/box"
service="/data/adb/service.d/gh_sing-box_service.sh"

if [ ! -d "${path}" ]; then
  exit 1
else
  rm -rf "${path}"
fi

if [ -f "${service}" ]; then
  rm -rf "${service}"
fi
