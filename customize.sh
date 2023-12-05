#!/system/bin/sh

### INSTALLATION ###
if [ "${BOOTMODE}" != true ]; then
  ui_print "-----------------------------------------------------------"
  ui_print "! Please install in Magisk Manager or KernelSU Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"

# check android
if [ "${API}" -lt 28 ]; then
  ui_print "! Unsupported sdk: ${API}"
  abort "! Minimal supported sdk is 28 (Android 9)"
else
  ui_print "- Device sdk: ${API}"
fi

# check version
if [ "${KSU}" = true ]; then
  ui_print "- This module only support Magisk"
  abort "Not supported KernelSU."
else
  ui_print "- Magisk version: ${MAGISK_VER} (${MAGISK_VER_CODE})"
fi

# check service
service_d="/data/adb/service.d"
if [ ! -d "${service_d}" ]; then
  mkdir -p "${service_d}"
fi

# install Ghitori Sing-Box
singbox_path="/data/adb/gh_sing-box"
ui_print "- Installing Ghitori Sing-Box"

mkdir -p "${singbox_path}/service"
mkdir -p "${singbox_path}/logs"
mkdir -p "${singbox_path}/cron"

# move scripts
mv ${MODPATH}/inotify.sh ${singbox_path}/service
mv ${MODPATH}/service.sh ${singbox_path}/service
mv ${MODPATH}/crond.sh ${singbox_path}/service
mv ${MODPATH}/gh_sing-box_service.sh ${service_d}

# creat config
if [ ! -f "${singbox_path}/config.txt" ];then
  cat>"${singbox_path}/config.txt"<<EOF
    sub="" 
    cron="0 4 * * *"
  EOF
fi

# set permissions
ui_print "- Setting permissions"
chmod +x ${MODPATH}/sing-box
chmod +x ${singbox_path}/service/*
chmod +x ${service_d}/gh_sing-box_service.sh

ui_print "- Installation completed, please restart your phone."