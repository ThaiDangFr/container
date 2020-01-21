#!/bin/bash

set -o errexit

buildah rmi mycentosvnc || true
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

# no need for dbus-x11 ?
buildah run $container yum -y install epel-release
buildah run $container yum -y install tigervnc-server fluxbox xterm wget unzip xorg-x11-apps xorg-x11-fonts* google-chrome-stable
buildah run $container yum clean all
buildah run $container useradd guac

cp ./guacamole/entrypoint.sh $mountpoint/root/entrypoint.sh

buildah config --entrypoint "/root/entrypoint.sh" $container
buildah commit --format docker $container mycentosvnc
buildah umount $containerid
umount $mountpoint
buildah rm $container
