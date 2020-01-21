#!/bin/bash

source $HOME/.bashrc

cat <<EOF > $HOME/.Xclients 
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
startfluxbox &
EOF

chmod 755 $HOME/.Xclients

mkdir $HOME/.vnc
chmod 755 $HOME/.vnc
echo 'mycentosvnc' | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

cat <<EOF > $HOME/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/etc/X11/xinit/xinitrc
EOF

chmod 755 $HOME/.vnc/xstartup

mkdir $HOME/bin

cat <<EOF > $HOME/bin/switchHome.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1920x1080
EOF

cat <<EOF > $HOME/bin/switchWork.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1280x1024
EOF

chmod 755 $HOME/bin/switchHome.sh $HOME/bin/switchWork.sh

echo "remove old vnc locks to be a reattachable container"
vncserver -kill :1 || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "no locks present"

#vncserver :1 -geometry 1024x768 -nolisten tcp -localhost
vncserver :1 -geometry 1024x768
sleep 5
tail -f $HOME/.vnc/*:1.log




