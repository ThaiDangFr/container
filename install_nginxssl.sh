#!/bin/bash

source ./vars.sh
PUB_PORT=${1:-80}
PUB_SPORT=${2:-443}

podman run --name mynginx --ip $NGINX_IP --add-host=diskstation:$DISKSTATION_IP --add-host=myguacamole:$GUACAMOLE_IP --add-host=myetherpad:$ETHERPAD_IP --add-host=myjspwiki:$JSPWIKI_IP  -p ${PUB_PORT}:80 -p ${PUB_SPORT}:443 -d localhost/mynginxssl
