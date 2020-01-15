#!/bin/bash

set -o errexit

container=$(buildah from centos:centos7.7.1908)
containerid=$(buildah containers --filter name=${container} -q)
mountpoint=$(buildah mount $containerid)

echo "container=$container"
echo "containerid=$containerid"
echo "mountpoint=$mountpoint"

buildah config --label maintainer="ThaiDangFr" $container

echo "[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" > ${mountpoint}/etc/yum.repos.d/google-chrome.repo

buildah run $container yum -y install epel-release tigervnc-server fluxbox xterm wget unzip xorg-x11-apps xorg-x11-fonts* dbus-x11 google-chrome-stable
buildah run $container yum clean all
buildah run $container useradd guac

cat <<EOF > $mountpoint/home/guac/.Xclients 
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
startfluxbox &
EOF

buildah run $container chmod 755 /home/guac/.Xclients
buildah run $container chown guac:guac $mountpoint/home/guac/.Xclients

buildah run $container su - guac -c "mkdir /home/guac/.vnc"
buildah run $container chmod 755 /home/guac/.vnc
buildah run $container su - guac -c "echo 'myvncpassword' | vncpasswd -f > /home/guac/.vnc/passwd"
buildah run $container chmod 600 /home/guac/.vnc/passwd

cat <<EOF > $mountpoint/home/guac/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/etc/X11/xinit/xinitrc
EOF

buildah run $container chmod 755 /home/guac/.vnc/xstartup
buildah run $container chown guac:guac /home/guac/.vnc/xstartup

buildah run $container su - guac -c "mkdir /home/guac/bin"

cat <<EOF > $mountpoint/home/guac/bin/switchHome.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1920x1080
EOF

cat <<EOF > $mountpoint/home/guac/bin/switchWork.sh
#!/bin/bash
xrandr --output VNC-0 --mode 1280x1024
EOF

buildah run $container chmod 755 /home/guac/bin/switchHome.sh /home/guac/bin/switchWork.sh
buildah run $container chown guac:guac /home/guac/bin/switchHome.sh /home/guac/bin/switchWork.sh

buildah config --entrypoint "su - guac -c 'vncserver :1 -geometry 1024x768 -nolisten tcp -localhost'" $container
buildah commit --format docker $container mycentosvnc
buildah unmount $containerid

