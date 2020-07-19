#!/bin/bash

set -o errexit

buildah rmi mynginx || true

container=$(buildah from docker.io/nginx:stable-alpine)
containerid=$(buildah containers --filter name=${container} -q)

echo "container=$container"
echo "containerid=$containerid"

buildah config --label maintainer="ThaiDangFr" $container

buildah run $container apk add inotify-tools certbot certbot-nginx openssl ca-certificates #openrc busybox-initscripts
buildah run $container rm -rf /var/cache/apk/*
#buildah run $container rc-service crond start
#buildah run $container rc-update add crond

buildah copy $container ./nginx/entrypoint.sh /root/entrypoint.sh
buildah copy $container ./nginx/*.conf /etc/nginx/conf.d/
buildah copy $container ./nginx/certbotcron /etc/periodic/monthly/

buildah run $container chmod 755 /root/entrypoint.sh /etc/periodic/monthly/certbotcron

buildah config --entrypoint "/root/entrypoint.sh" $container
buildah commit --format docker $container mynginx
#buildah umount $containerid
buildah rm $container
