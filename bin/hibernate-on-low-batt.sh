#!/bin/sh
batt_threshold=5

acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
  read -r status capacity
  # echo "$status $capacity" > /tmp/batt.txt
  if [ "$status" = Discharging ]; then
    if [ "$capacity" -lt "$batt_threshold" ]; then
      logger "$0: Critical battery threshold"
      # echo "hib" > /tmp/hib.txt
      /usr/bin/systemctl hibernate
    elif [ "$capacity" -lt "$(($batt_threshold + 2))" ]; then
      # echo "hib-warn" > /tmp/hibwarn.txt
      DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /usr/bin/notify-send "Battery Low" "System will hibernate soon..." -u CRITICAL
    fi
  fi

}
