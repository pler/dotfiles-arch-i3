#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# load style
xrdb -merge $HOME/.Xresources &

# keyboard rate
xset r rate 200 30 &

# disable bell
xset -b &

# enable zapping
setxkbmap -option terminate:ctrl_alt_bksp &

# set bg image
WALLPAPERFILE=$HOME/wallpaper.jpg
if [ -f $WALLPAPERFILE ]; then
  feh --bg-scale $WALLPAPERFILE &
fi

# some machine-specific commands
case `hostname -s` in
  "phil-laptop-linux")
    setxkbmap de &
    nm-applet &
    xrandr --output LVDS1 --auto --primary --output VGA1 --off &
    xautolock -time 5 -locker '$HOME/bin/i3exit.sh lock' &
  ;;
  "phil-desktop-linux")
    # compton
    compton -d --vsync opengl --backend glx --glx-swap-method 1 &
    # autoconfigure multihead
    xrandr --output DVI-I-1 --auto --primary --output DVI-I-2 --auto --right-of DVI-I-1  &
  ;;
*) ;; #default
esac

exec i3
