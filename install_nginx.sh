#!/bin/bash

mkdir -p $HOME/run/nginx/cfg
chmod 777 $HOME/run/nginx/cfg

cp ./nginx/container.conf $HOME/run/nginx/cfg/

podman run --name mynginx --ip=10.88.0.10 --add-host=myguacamole:10.88.0.11 --add-host=myetherpad:10.88.0.13 --add-host=myjspwiki:10.88.0.14  -p 80:80 -v $HOME/run/nginx/cfg/container.conf:/etc/nginx/conf.d/container.conf:z -d docker.io/nginx:stable-alpine
