#!/bin/bash

set -o errexit

buildah rmi mycentosvnc || true
container=$(buildah from centos:centos7.7.1908)
containerid=$(buildah containers --filter name=${container} -q)

echo "container=$container"
echo "containerid=$containerid"

buildah config --label maintainer="ThaiDangFr" $container
buildah run $container useradd guac

buildah copy $container ./guacamole/google-chrome.repo /etc/yum.repos.d/
buildah copy $container ./guacamole/entrypoint.sh /root/entrypoint.sh
buildah run $container mkdir /home/guac/.fluxbox
buildah copy $container ./guacamole/wallpaper.jpg /home/guac/.fluxbox/
buildah run $container chown -R guac:guac /home/guac/.fluxbox/

buildah run $container yum -y install epel-release
buildah run $container yum -y install tigervnc-server fluxbox xterm wget unzip xorg-x11-apps xorg-x11-fonts* google-chrome-stable ImageMagick 
buildah run $container -- yum clean all && rm -rf /var/cache/yum

buildah config --entrypoint "/root/entrypoint.sh" $container
buildah commit --format docker $container mycentosvnc
buildah rm $container
