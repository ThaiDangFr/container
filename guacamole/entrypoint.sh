#!/bin/bash

source $HOME/.bashrc

echo "mycentosvnc" | passwd --stdin root

cat <<EOF > /home/guac/.Xclients 
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
startfluxbox &
EOF

chmod 755 /home/guac/.Xclients
chown guac:guac /home/guac/.Xclients

su - guac -c "mkdir /home/guac/.vnc"
chmod 755 /home/guac/.vnc
su - guac -c "echo 'mycentosvnc' | vncpasswd -f > /home/guac/.vnc/passwd"
chmod 600 /home/guac/.vnc/passwd

cat <<EOF > /home/guac/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/etc/X11/xinit/xinitrc
EOF

chmod 755 /home/guac/.vnc/xstartup
chown guac:guac /home/guac/.vnc/xstartup

cat <<EOF> /home/guac/.fluxbox/overlay
background: aspect
background.pixmap: ~/.fluxbox/wallpaper.jpg
EOF

cat <<EOF> /home/guac/.fluxbox/init
session.menuFile:       ~/.fluxbox/usermenu
session.keyFile: ~/.fluxbox/keys
session.styleFile: /usr/share/fluxbox/styles/bloe
session.configVersion:  13
session.styleOverlay:   /home/guac/.fluxbox/overlay
EOF

cat <<EOF> /home/guac/.fluxbox/usermenu
[begin] (Fluxbox-1.3.7)
[encoding] {UTF-8}
      [exec] (xterm) {xterm}
      [exec] (google-chrome) {/bin/google-chrome}
[submenu] (Fluxbox menu)
      [config] (Configure)
[submenu] (System Styles) {Choose a style...}
      [stylesdir] (/usr/share/fluxbox/styles)
[end]
[submenu] (User Styles) {Choose a style...}
      [stylesdir] (~/.fluxbox/styles)
[end]
      [workspaces] (Workspace List)
      [commanddialog] (Fluxbox Command)
      [reconfig] (Reload config)
      [restart] (Restart)
      [exec] (About) {(fluxbox -v; fluxbox -info | sed 1d) | xmessage -file - -center}
      [separator]
      [exit] (Exit)
[end]
[endencoding]
[end]
EOF

chown -R guac:guac /home/guac/.fluxbox

su - guac -c "mkdir /home/guac/bin"

cat <<EOF > /home/guac/bin/switchHome.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1920x1080
EOF

cat <<EOF > /home/guac/bin/switchWork.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1280x1024
EOF

chmod 755 /home/guac/bin/switchHome.sh /home/guac/bin/switchWork.sh
chown guac:guac /home/guac/bin/switchHome.sh /home/guac/bin/switchWork.sh

echo "remove old vnc locks to be a reattachable container"
su - guac -c "vncserver -kill :1" || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "no locks present"

#su - guac -c "vncserver :1 -geometry 1024x768 -nolisten tcp -localhost"
su - guac -c "vncserver :1 -geometry 1024x768"
sleep 5
tail -f /home/guac/.vnc/*:1.log




