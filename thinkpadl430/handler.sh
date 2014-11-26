#!/bin/bash
# adjusted acpi script for lenovo l430
# location: /etc/acpi/handler.sh

# output from acpi_listen is sent to this script as $1 $2 $3 $4
# example: button/power PBTN 00000080 00000000

case "$1" in

button/volumedown)
  amixer -c 0 set Master 2dB-
;;

button/volumeup)
  amixer -c 0 set Master 2dB+
;;

button/mute)
  amixer set Master toggle
;;

button/f20) # microphone mute button
	# amixer set Mic toggle
;;

button/prog1) # media button
  # ...
;;

button/power)
  # handled by thinkpad_acpi
;;

button/screenlock)
  # i3lock -c 111111 -d
;;

button/sleep)
  # handled by thinkpad_acpi
;;

button/wlan)
  # handled by thinkpad_acpi
;;

video/switchmode) # video output switch
  # cycle monitor modes (single vs extended)
  # cyclecommand="disper --cycle --cycle-stages=-s:-e"
  # su phil - -c "XAUTHORITY=/home/phil/.Xauthority DISPLAY=:0 $(printf '%q ' $cyclecommand)" &
  # su phil - -c "XAUTHORITY=/home/phil/.Xauthority DISPLAY=:0 $(printf '%q ' notify-send "Monitor" "$cyclecommand")" &
;;

video/brightnessdown)
  # handled by thinkpad_acpi
;;

video/brightnessup)
  # handled by thinkpad_acpi
;;

cd/prev)
  # ...
;;

cd/play)
  # ...
;;

cd/next)
  # ...
;;

button/lid)
  case "$3" in close)
      logger 'LID closed'
    ;;
    open)
      logger 'LID opened'
    ;;
  esac
;;

jack/headphone)
  case "$3" in plug)
      # amixer -c 0 set Master unmute
    ;;
    unplug)
      amixer -c 0 set Master mute
    ;;
  esac
;;

jack/microphone)
  # same slot as the headphone jack
  # only gets activated when a plugged in device is removed
;;

ac_adapter)
  case "$2" in ACPI*|AC|ACAD|ADP0)
      maxbrightness=$(< /sys/class/backlight/intel_backlight/max_brightness)
      case "$4" in
        00000000)
          # lower brightness
          echo -n $(awk "BEGIN {printf \"%d\",${maxbrightness}*0.6}") > /sys/class/backlight/intel_backlight/brightness
        ;;
        00000001)
          # heighten brightness
          echo -n $(awk "BEGIN {printf \"%d\",${maxbrightness}*1.0}") > /sys/class/backlight/intel_backlight/brightness
        ;;
      esac
      ;;
  *) logger "ACPI action undefined: $2" ;;
  esac
;;

battery)
  case "$2" in PNP*)
      case "$4" in
        00000000)
          logger 'Battery unplugged'
          ;;
        00000001)
          logger 'Battery plugged'
          ;;
      esac
      ;;
  # CPU0)
  # ;;
  *) logger "ACPI action undefined: $2" ;;
  esac
;;

*) logger "ACPI group/action undefined: $1 / $2" ;;
esac
# vim:set ts=4 sw=4 ft=sh et:
