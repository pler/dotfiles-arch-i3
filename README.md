# Arch Linux dotfiles

This repository contains my personal configuration files.

## Installation
```sh
git clone https://github.com/pler/dotfiles-arch-i3.git
cd dotfiles-arch-i3
chmod +x create-symlinks.py
./create-symlinks.py
```

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

### zsh
* install: `zsh` `zsh-grml-config` `zsh-completions`
* install: `zsh-syntax-highlighting-git` `zsh-history-substring-search-git`
* add to `~/.zshrc` (in that order):<br>`source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`<br>`source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh`
* change shell `chsh -s /usr/bin/zsh`, check `/etc/shells` and `/etc/passwd`

### terminal tmulator
* install: `rxvt-unicode`

### basic tools
* `htop` `tree`

## Graphics

### Xorg
* install: `xorg` `xorg-xinit`
* optional: `xterm` `xorg-twm`
* add to `.xinitrc` to enable zapping:<br> `setxkbmap -option terminate:ctrl_alt_bksp`
* add to `.xinitrc` to heighten keyboard rate: `xset r rate 200 30`

### graphics drivers
* identify card via `lscpi | grep -e VGA -e 3D`
* nouveau: `xf86-video-nouveau`<br>
  nvidia: `nvidia`<br>
* Bumblebee (Optimus)
  1. switch to integrated graphics in *BIOS*
  2. (remove old drivers `nvidia` `xf86-video-nouveau`, `nouveau-dri`)
  3. install: `mesa`
  4. install: `nvidia` `nvidia-utils`
  5. install:`bumblebee` `bbswitch` `primus`
  6. run `systemctl enable bumblebeed`
  7. reboot to *BIOS*, switch to Optimus
  8. test via `optirun glxgears -info` (package: `mesa-demos`)<br> check `cat /proc/acpi/bbswitch`

### Multihead
* `xrandr` to see attached monitors
* add to `.xinitrc`:<br>`xrandr --output <primary> --auto --primary --output <secondary> --auto --right-of <primary>`
* GUI: `lxrandr`


## i3 (UI)

1. install: `i3-wm` `i3lock` `i3status` `dmenu`
2. `[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx` in `.bash_profile` or `.zlogin` or `.zprofile`
3. `cp /etc/skel/.xinitrc ~/ && echo 'exec i3' >> ~/.xinitrc `

### fixed font rendering
1. add to `/etc/pacman.conf`:
```
[infinality-bundle]
Server = http://bohoomil.com/repo/$arch
[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/$arch
```
2. add & sign key: `pacman-key -r 962DDE58` & `pacman-key --lsign-key 962DDE58`
4. install: `infinality-bundle`
5. (additional fonts: `ibfonts-meta-base`)

https://wiki.archlinux.org/index.php/Infinality-bundle+fonts


### status bar
* install: `conky`

### GTK
* GUI config tool: `lxappearance`
* themes & icons: `gnome-themes-standard` `faenza-icon-theme`


### Compton (optional)
* install: `compton-git`
* add to `.xinitrc`: `exec --no-startup-id compton -d --vsync opengl`<br> (note: use `--backend glx` with good gpu)


## System

### time correction
* install: `ntp`
* add `de.pool.ntp.org` to `/etc/ntp.conf`
* sync time via `ntpd -gq` (check if correct via `date`)
* set hardware clock `hwclock -w`

### USB & NTFS
* install `udisks2` `gvfs` `gvfs-afc`
* install `ntfs-3g` `ntfs-config`
* in **WINDOWS** administrator CMD: `powercfg /h off` (disables hibernation & fast restarting which block permissions)
* run `ntfs-config`, check `/etc/fstab`

### sound
* install: `alsa-utils` `playerctl`


## Additional software

### General
* `thunar` `xarchive` `ristretto` `evince`

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

### Misc
* `shellcheck`

