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

thunar --daemon &

# programs to run with X
#exec chromium --disable-sync-preferences --no-startup-window &
#exec chromium --no-startup-window &
exec dropboxd &
exec skype &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
xmodmap -e "keycode 133 = Super_L" -e "add mod4 = Super_L"
exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
