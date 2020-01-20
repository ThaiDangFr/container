#!/bin/bash

source ./vars.sh
PUB_PORT=${1:-80}

mkdir -p $HOME/run/nginx/cfg
chmod 777 $HOME/run/nginx/cfg

cp ./nginx/container.conf $HOME/run/nginx/cfg/

podman run --name mynginx --ip $NGINX_IP --add-host=diskstation:$DISKSTATION_IP --add-host=myguacamole:$GUACAMOLE_IP --add-host=myetherpad:$ETHERPAD_IP --add-host=myjspwiki:$JSPWIKI_IP  -p ${PUB_PORT}:80 -v $HOME/run/nginx/cfg/container.conf:/etc/nginx/conf.d/container.conf:z -d docker.io/nginx:stable-alpine
