#!/bin/sh
echo "{\"version\":1, \"click_events\": true}"
echo "[[]"
conky -c $HOME/.i3/conkyrc -d

IFS="}"
while read;do
  IFS=" "
  STR=`echo $REPLY | sed -e s/[{}]//g -e "s/ \"/\"/g" | awk '{n=split($0,a,","); for (i=1; i<=n; i++) {m=split(a[i],b,":"); if (b[1] == "\"name\"") {NAME=b[2]} if (b[1] =="\"x\"") {X=b[2]} if (b[1] =="\"y\"") {Y=b[2]} } print NAME " " X " " Y}'`
  read NAME X Y <<< $STR
  X=$(($X-50))
  case "${NAME}" in
    \"keyboard\")
      $HOME/bin/keyboardswitch.sh
    ;;
    
    \"volume\")
      amixer set Master toggle > /dev/null
    ;;

    *) ;;# default
  esac
IFS="}"
done
