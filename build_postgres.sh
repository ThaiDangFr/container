#!/bin/bash

set -o errexit

container=$(buildah from docker.io/library/postgres:12.1)
containerid=$(buildah containers --filter name=${container} -q)

echo "container=$container"
echo "containerid=$containerid"

buildah config --label maintainer="ThaiDangFr" $container

podman run --rm guacamole/guacamole:1.0.0 /opt/guacamole/bin/initdb.sh --postgres > ./guacamole/initdb.sql
chmod 755 ./guacamole/initdb.sql

buildah copy $container ./guacamole/initdb.sql /docker-entrypoint-initdb.d/

buildah commit --format docker $container mypostgres
buildah rm $container
