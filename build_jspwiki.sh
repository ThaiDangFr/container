#!/bin/bash

set -o errexit

buildah rmi myjspwiki || true

container=$(buildah from docker.io/metskem/docker-jspwiki:2.11.0-M5)
containerid=$(buildah containers --filter name=${container} -q)

echo "container=$container"
echo "containerid=$containerid"

buildah config --label maintainer="ThaiDangFr" $container

#buildah run $container apk add inotify-tools certbot certbot-nginx openssl ca-certificates
#buildah copy $container ./nginx/entrypoint.sh /root/entrypoint.sh

buildah copy $container ./jspwiki/favicon/* /usr/local/tomcat/webapps/ROOT/favicons/
buildah copy $container ./jspwiki/jspwiki.policy /usr/local/tomcat/webapps/ROOT/WEB-INF/jspwiki.policy
buildah copy $container ./jspwiki/jspwiki-custom.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jspwiki-custom.properties


buildah commit --format docker $container myjspwiki
buildah rm $container
