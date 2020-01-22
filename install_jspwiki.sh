#!/bin/bash

source ./vars.sh

mkdir -p $HOME/run/jspwiki/pages $HOME/run/jspwiki/etc $HOME/run/jspwiki/webinf
chmod -R 755 $HOME/run/jspwiki
chown -R 1000:1000 $HOME/run/jspwiki

cp ./jspwiki/jspwiki.policy $HOME/run/jspwiki/webinf/jspwiki.policy

# jspwiki port is 8080
# -e jspwiki_baseURL=https://jspwiki.dangconsulting.fr/
podman run -d --name myjspwiki --hostname=myjspwiki --ip $JSPWIKI_IP -v=$HOME/run/jspwiki/webinf/jspwiki.policy:/usr/local/tomcat/webapps/ROOT/WEB-INF/jspwiki.policy:z -v=$HOME/run/jspwiki/etc:/var/jspwiki/etc:z  -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z docker.io/metskem/docker-jspwiki:2.11.0-M5
