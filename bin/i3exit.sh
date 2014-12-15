#!/bin/sh

lock() {
  i3lock -f
}

case "$1" in
    lock)
      lock
      ;;
    logout)
      i3-msg exit
      ;;
    suspend)
      lock && systemctl suspend
      ;;
    reboot)
      systemctl reboot
      ;;
    shutdown|poweroff)
      systemctl poweroff
      ;;
    *)
      echo "Usage: $0 {lock|logout|suspend|reboot|shutdown}"
      exit2
      ;;
esac

exit 0
