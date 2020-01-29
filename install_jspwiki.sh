#!/bin/bash
# JSPWiki working directory is '/var/jspwiki/work'
# logs : /var/jspwiki/logs/jspwiki.log

source ./vars.sh

mkdir -p $HOME/run/jspwiki/pages $HOME/run/jspwiki/etc
chmod -R 755 $HOME/run/jspwiki
chown -R 1000:1000 $HOME/run/jspwiki

cp ./jspwiki/jspwiki-wikipages-fr/* $HOME/run/jspwiki/pages/

# jspwiki port is 8080
podman run -d --name myjspwiki --hostname=myjspwiki --ip $JSPWIKI_IP -e jspwiki_baseURL=https://jspwiki.dangconsulting.fr/ -e jspwiki_jspwiki_frontPage=Main -v=$HOME/run/jspwiki/etc:/var/jspwiki/etc:z  -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z localhost/myjspwiki


