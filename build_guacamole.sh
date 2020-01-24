#!/bin/bash

set -o errexit

container=$(buildah from docker.io/guacamole/guacamole:1.0.0)
containerid=$(buildah containers --filter name=${container} -q)

echo "container=$container"
echo "containerid=$containerid"

buildah config --label maintainer="ThaiDangFr" $container
buildah copy $container ./guacamole/guacamole-auth-totp-1.0.0.jar /opt/guacamole/postgresql/

buildah commit --format docker $container myguacamole
buildah rm $container
