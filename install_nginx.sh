#!/bin/bash

mkdir -p $HOME/run/nginx/cfg
chmod 777 $HOME/run/nginx/cfg

cp ./nginx/default.conf $HOME/run/nginx/cfg/

podman run --name mynginx --network=mynetwork  -p 2000:80 -v $HOME/run/nginx/cfg/default.conf:/etc/nginx/conf.d/default.conf:z -d docker.io/nginx:stable-alpine
