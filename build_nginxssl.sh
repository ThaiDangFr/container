#!/bin/bash

set -o errexit

buildah rmi mynginxssl || true

container=$(buildah from docker.io/nginx:stable-alpine)
containerid=$(buildah containers --filter name=${container} -q)
mountpoint=$(buildah mount $containerid)

echo "container=$container"
echo "containerid=$containerid"
echo "mountpoint=$mountpoint"

buildah config --label maintainer="ThaiDangFr" $container

cp -r ./nginxssl/ssl-options ${mountpoint}/etc/

buildah run $container apk add inotify-tools certbot openssl ca-certificates

cp ./nginxssl/entrypoint.sh $mountpoint/root/entrypoint.sh
cp ./nginxssl/http.conf $mountpoint/etc/nginx/conf.d/http.conf
cp ./nginxssl/https.conf $mountpoint/etc/nginx/conf.d/https.conf

buildah config --entrypoint "/root/entrypoint.sh" $container
buildah commit --format docker $container mynginxssl
buildah umount $containerid
umount $mountpoint
buildah rm $container
