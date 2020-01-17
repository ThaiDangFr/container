#!/bin/bash

mkdir -p $HOME/run/jspwiki/pages
chmod 777 $HOME/run/jspwiki/pages

podman run -d -p 2004:8080 --name myjspwiki --env="jspwiki_baseURL=http://localhost/" --volume="$HOME/run/jspwiki/pages:/var/jspwiki/pages" docker.io/metskem/docker-jspwiki:2.11.0-M5
