#!/bin/bash

mkdir -p $HOME/run/jspwiki/pages
chmod 755 $HOME/run/jspwiki/pages
chown -R 1000:1000 $HOME/run/jspwiki/pages

# jspwiki port is 8080
podman run -d --name myjspwiki --hostname=myjspwiki --ip=10.88.0.14 --env="jspwiki_baseURL=http://localhost/" -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z docker.io/metskem/docker-jspwiki:2.11.0-M5
