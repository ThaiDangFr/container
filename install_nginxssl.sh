#!/bin/bash

source ./vars.sh
PUB_PORT=${1:-80}
PUB_SPORT=${2:-443}
ENVT=${3:-TEST}

mkdir -p $HOME/run/nginx/letsencrypt

podman run --name mynginx -v $HOME/run/nginx/letsencrypt:/etc/letsencrypt:z -e ENVT=$ENVT --ip $NGINX_IP --add-host=diskstation:$DISKSTATION_IP --add-host=myguacamole:$GUACAMOLE_IP --add-host=myetherpad:$ETHERPAD_IP --add-host=myjspwiki:$JSPWIKI_IP  -p ${PUB_PORT}:80 -p ${PUB_SPORT}:443 -d localhost/mynginxssl
