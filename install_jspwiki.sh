#!/bin/bash

mkdir -p $HOME/run/jspwiki/pages
chmod 755 $HOME/run/jspwiki/pages
chown -R 1000:1000 $HOME/run/jspwiki/pages

podman run -d -p 2004:8080 --name myjspwiki --network=mynetwork --env="jspwiki_baseURL=http://localhost/" -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z docker.io/metskem/docker-jspwiki:2.11.0-M5
