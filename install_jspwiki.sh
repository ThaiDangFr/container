#!/bin/bash
# JSPWiki working directory is '/var/jspwiki/work'
# logs : /var/jspwiki/logs/jspwiki.log

source ./vars.sh

mkdir -p $HOME/run/jspwiki/pages $HOME/run/jspwiki/etc $HOME/run/jspwiki/webinf
chmod -R 755 $HOME/run/jspwiki
chown -R 1000:1000 $HOME/run/jspwiki

cp ./jspwiki/jspwiki.policy $HOME/run/jspwiki/webinf/jspwiki.policy
cp ./jspwiki/jspwiki-custom.properties $HOME/run/jspwiki/webinf/jspwiki-custom.properties
cp ./jspwiki/jspwiki-wikipages-fr/* $HOME/run/jspwiki/pages/

# jspwiki port is 8080
podman run -d --name myjspwiki --hostname=myjspwiki --ip $JSPWIKI_IP -e jspwiki_baseURL=https://jspwiki.dangconsulting.fr/ -e jspwiki_jspwiki_frontPage=Main -v=$HOME/run/jspwiki/webinf/jspwiki.policy:/usr/local/tomcat/webapps/ROOT/WEB-INF/jspwiki.policy:z -v=$HOME/run/jspwiki/webinf/jspwiki-custom.properties:/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jspwiki-custom.properties:z  -v=$HOME/run/jspwiki/etc:/var/jspwiki/etc:z  -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z docker.io/metskem/docker-jspwiki:2.11.0-M5


# podman run -d --name myjspwiki --hostname=myjspwiki --ip $JSPWIKI_IP -e CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djspwiki.custom.config=/usr/local/apache-tomcat/webapps/ROOT/WEB-INF/classes/jspwiki-custom.properties" -e jspwiki_baseURL=https://jspwiki.dangconsulting.fr/ -e jspwiki_jspwiki_frontPage=Main -v=$HOME/run/jspwiki/webinf/jspwiki.policy:/usr/local/tomcat/webapps/ROOT/WEB-INF/jspwiki.policy:z -v=$HOME/run/jspwiki/webinf/jspwiki-custom.properties:/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jspwiki-custom.properties:z  -v=$HOME/run/jspwiki/etc:/var/jspwiki/etc:z  -v=$HOME/run/jspwiki/pages:/var/jspwiki/pages:z docker.io/metskem/docker-jspwiki:2.11.0-M5
