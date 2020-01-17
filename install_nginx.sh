#!/bin/bash

mkdir -p $HOME/run/nginx/cfg
chmod 777 $HOME/run/nginx/cfg

cp ./nginx/nginx.conf $HOME/run/nginx/cfg/

podman run --name mynginx -p 2000:80 -v $HOME/run/nginx/cfg/nginx.conf:/etc/nginx/nginx.conf:ro -d docker.io/nginx:1.17.7
