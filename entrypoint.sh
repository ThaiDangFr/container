#!/bin/bash

cat <<EOF > /home/guac/.Xclients 
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
#startfluxbox &
EOF

chmod 755 /home/guac/.Xclients
chown guac:guac /home/guac/.Xclients

su - guac -c "mkdir /home/guac/.vnc"
chmod 755 /home/guac/.vnc
su - guac -c "echo 'myvncpassword' | vncpasswd -f > /home/guac/.vnc/passwd"
chmod 600 /home/guac/.vnc/passwd

cat <<EOF > /home/guac/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/etc/X11/xinit/xinitrc
EOF

chmod 755 /home/guac/.vnc/xstartup
chown guac:guac /home/guac/.vnc/xstartup

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
vncserver -kill :1 || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "no locks present"

vncserver :1 -geometry 1024x768 -nolisten tcp -localhost
/usr/bin/startfluxbox &





