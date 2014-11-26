# Arch Linux dotfiles

This repository contains my personal configuration files.

```sh
git clone https://github.com/pler/dotfiles-arch-i3.git
cd dotfiles-arch-i3
chmod +x create-symlinks.py
./create-symlinks.py
```

-------------------------------------------------------------------------------
# Post-installation

Some personal notes for my setup...

## Package Management

### automatically updated & rated mirror list
1. install: `reflector`
2. create new service: `/etc/systemd/system/reflector.service`
  ```
  [Unit]
  Description=Pacman mirrorlist update

  [Service]
  Type=oneshot
  ExecStart=/usr/bin/reflector --protocol http --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist
  ```
3. add timer for weekly update: `/etc/systemd/system/reflector.timer`
  ```
  [Unit]
  Description=Run reflector weekly

  [Timer]
  OnCalendar=weekly
  AccuracySec=12h
  Persistent=true

  [Install]
  WantedBy=timers.target
  ```
4. enable timer: `systemctl enable reflector.timer`

### yaourt (AUR)
1. download tarballs
  * https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
  * https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
2. unzip and install `tar zxvf *.tar.gz` & `cd *` & `makepkg -si`


## CLI

* install: `rxvt-unicode`
* install: `zsh` `zsh-grml-config` `zsh-completions`
  * install: `zsh-syntax-highlighting-git` `zsh-history-substring-search-git`
  * add to `~/.zshrc` (in that order):<br>`source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`<br>`source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh`
  * change shell `chsh -s /usr/bin/zsh`, check `/etc/shells` and `/etc/passwd`

## Graphics

### Xorg
* install: `xorg` `xorg-xinit` # `xterm` `xorg-twm`
* add to `.xinitrc` to enable zapping:<br> `setxkbmap -option terminate:ctrl_alt_bksp`
* add to `.xinitrc` to heighten keyboard rate:<br> `xset r rate 200 30`

### graphics drivers
* identify card via `lscpi | grep -e VGA -e 3D`
* install: `xf86-video-nouveau` || `nvidia`
* for optimus/bumblebee:
  1. switch to integrated graphics in *BIOS*
  2. (remove old drivers `nvidia` `xf86-video-nouveau` `nouveau-dri`)
  3. install: `mesa`
  4. install: `nvidia` `nvidia-utils`
  5. install:`bumblebee` `bbswitch` `primus`
  6. run `systemctl enable bumblebeed`
  7. reboot to *BIOS*, switch to Optimus
  8. test via `optirun glxgears -info` (package: `mesa-demos`)<br> check `cat /proc/acpi/bbswitch`

### Multihead
* `xrandr` to see attached monitors
* add to `.xinitrc`:<br>`xrandr --output <primary> --auto --primary --output <secondary> --auto --right-of <primary>`
* GUI: `lxrandr`, CLI: `disper`


## i3

1. install: `i3-wm` `i3lock` `i3status` `dmenu`
2. add to (`.bash_profile` && (`.zlogin` || `.zprofile`)):<br>`[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx`
3. `cp /etc/skel/.xinitrc ~/ && echo 'exec i3' >> ~/.xinitrc `

### fix font rendering
1. add to `/etc/pacman.conf`:
```
[infinality-bundle]
Server = http://bohoomil.com/repo/$arch
[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/$arch
```
2. add & sign key: `pacman-key -r 962DDE58` && `pacman-key --lsign-key 962DDE58`
4. install: `infinality-bundle`
5. (additional fonts: `ibfonts-meta-base`)

https://wiki.archlinux.org/index.php/Infinality-bundle+fonts

### GTK
* GUI config tool: `lxappearance`
* themes & icons: `gnome-themes-standard` `faenza-icon-theme`

### Compton (optional)
* install: `compton-git`
* add to `.xinitrc`:<br> `exec --no-startup-id compton -d --vsync opengl`<br> (use `--backend glx` with good gpu)

### Enhancements
* for a better status bar, install: `conky`
  * config
* for a notification manager, install: `dunst`
* clipboard manager: `xclip`



## System

### time correction
* install: `ntp`
* add `de.pool.ntp.org` to `/etc/ntp.conf`
* sync time via `ntpd -gq` (check if correct via `date`)
* set hardware clock `hwclock -w`
* NOTE: configure WINDOWS to use UTC
  1. Disable "Internet Time Update"
  2. Using `regedit`, add a `DWORD` value with hex value `1` to the registry<br>
  `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\RealTimeIsUniversal`


### USB & NTFS
* install: `udisks2` `gvfs` `gvfs-afc` `ntfs-3g` `ntfs-config`
* Disable hibernation & fast restarting *in WINDOWS* which block permissions
  * `powercfg /h off`
* run `ntfs-config`, check `/etc/fstab`

### SSD
* veritfy TRIM support via `hdparm -I /dev/sda | grep TRIM`
* chose one of the following options
  1. online: using `discard` flag
    * add to it to `/etc/fstab`<br>
    ex. `/dev/sda1  /       ext4   defaults,noatime,discard   0  1`
  2. offline: regular TRIM via a systemd service
    * install `util-linux` (provides `fstrim.service` and `fstrim.timer`)
    * `systemctl enable fstrim.timer` (weekly)


### sound
* install: `alsa-utils` `playerctl`


## Additional software

### General
* `htop` `tree`
* `thunar` `xarchive` `ristretto` `evince`
* `shellcheck`

### Python
* `python`, `python-pip` # `python2` `python2-pip`
* `pip install pep8`

### Java
* `jdk8-openjdk` or `jdk7-openjdk`
* switch between environments via `archlinux-java <status|get|set X|unset|fix>`
* fix font rendering and make swing use GTK look and feel:<br> `export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'`

### Fonts
* `adobe-source-code-pro-fonts` `ttf-dejavu` `ubuntu-font-family` `ttf-monaco`
* manual font installation: `mv *.ttf /usr/share/fonts/TTF`, update font cache `fc-cache -vf`
* `xorg-xfontsel` to select X11 fonts, `gtk2fontsel` for xft fonts (GUI)


-------------------------------------------------------------------------------
# Thinkpad L430s

* for the touchpad, install:`x86-input-synaptics`
* for the webcam, install: `guvcview`
* relevant: https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T420

## Power management
* install: `powertop`
  * check and enable tunables (wifi, audio, SATA link, usb power mgmt)
* (additional tools: `tlp` || `laptop-power-mode`)
* install: `thinkfan`
  * config file: `/etc/thinkfan.conf`, example: `/usr/share/doc/thinkfan/examples/thinkfan.conf.simple`
  and adjust values
* **TODO**: timed suspend, bluetooth

## ACPI

* handles some basic controls, install: `thinkpad_acpi`
* additional ACPI support, install: `acpid`
  * bindings can be found in `/etc/acpi/handler.sh`
* brightness controls didn't work out of the box (no scancodes for the keys) until I booted with `acpi_backlight=vendor acpi_osi=Linux` as kernel parameters

### ACPI events
Event | Key | acpid event | comment | handeled via thinkpad_aci | keysym
--- | --- | --- | --- | --- | ---
mute | | `button/mute MUTE 00000080 00000000` | | | `XF86AudioMute`
volume - | | `button/volumedown VOLDN 00000080 00000000` | | | `XF86AudioLowerVolume`
volume + | | `button/volumeup VOLUP 00000080 00000000` | | | `XF86AudioRaiseVolume`
mute microphone | | `button/f20 F20 00000080 00000000` | | | `XF86AudioMicMute`
media button | | `button/prog1 PROG1 00000080 00000000` | | | `XF86Launch1`
power button | | `button/power PBTN 00000080 00000000` |  | shutdown |
lock | *fn+f3* | `button/screenlock SCRNLCK 00000080 00000000` | | | `XF86ScreenSaver`
sleep | *fn+f4* | `button/sleep SBTN` | | x | `XF86Sleep`
wifi toggle | *fn+f5* | `button/wlan WLAN 00000080 00000000` | | x | `XF86WLAN`
webcam | *fn+f6* | | | | `XF86WebCam`
display | *fn+f7* | `video/switchmode VMOD 00000080 00000000` | | | `XF86Display`
brightness -| *fn+f8* | `video/brightnessdown BRTDN 00000087 00000000` <br> `ibm/hotkey LEN0068 00000080 00006050` | | x | `XF86WakeUp`
brightness +| *fn+f9* | `video/brightnessup BRTUP 00000086 00000000` <br> `ibm/hotkey LEN0068 00000080 00006050` | | x | `XF86WakeUp`
music prev | *fn+f10* | `cd/prev CDPREV 00000080 00000000` | | | `XF86AudioPrev`
music play | *fn+f11* | `cd/play CDPLAY 00000080 00000000` | | | `XF86AudioPlay`
music next | *fn+f12* | `cd/next CDNEXT 00000080 00000000` | | | `XF86AudioNext`
lid open | | `button/lid LID open` | | turns laptop screen off |
lid close | | `button/lid LID close` | | turns laptop screen on |
audio/mic in | | `jack/headphone HEADPHONE plug` | | redirects audio to plugged device |
audio/mic out | | `jack/headphone HEADPHONE unplug`<br>`jack/microphone MICROPHONE plug`<br>`jack/microphone MICROPHONE unplug` | | redirects audio to speakers |
ac disconnect | | `ac_adapter ACPI0003:00 00000080 00000000`<br>`processor LNXCPU:00 00000081 00000000`<br>`processor LNXCPU:01 00000081 00000000`<br>`processor LNXCPU:02 00000081 00000000`<br>`processor LNXCPU:03 00000081 00000000`<br>`battery PNP0C0A:00 00000080 00000001` | | |
ac connect | | `battery PNP0C0A:00 00000080 00000001`<br>`ac_adapter ACPI0003:00 00000080 00000001`<br>`processor LNXCPU:00 00000081 00000000`<br>`processor LNXCPU:01 00000081 00000000`<br>`processor LNXCPU:02 00000081 00000000`<br>`processor LNXCPU:03 00000081 00000000` | | |
battery out | | `battery PNP0C0A:00 00000081 00000000` | after a delay | |
battery in | | `battery PNP0C0A:00 00000081 00000001`<br>`battery PNP0C0A:00 00000080 00000001` | after a delay | |

recorded via `acpi_listen` or `journalctl -f`
