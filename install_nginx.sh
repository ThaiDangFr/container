#!/bin/bash

mkdir -p $HOME/run/nginx/cfg
chmod 777 $HOME/run/nginx/cfg

cp ./nginx/container.conf $HOME/run/nginx/cfg/

podman run --name mynginx -p 2000:80 -v $HOME/run/nginx/cfg/container.conf:/etc/nginx/conf.d/container.conf:ro -d docker.io/nginx:1.17.7
