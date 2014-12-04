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
xrdb -merge $HOME/.Xresources

# keyboard rate
xset r rate 200 30

# enable zapping
setxkbmap -option terminate:ctrl_alt_bksp

# compton
compton -d --vsync opengl --backend glx --glx-swap-method 1

# autoconfigure multihead
xrandr --output DVI-I-1 --auto --primary --output DVI-I-2 --auto --right-of DVI-I-1

exec i3
