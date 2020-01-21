#!/bin/sh

SUBDOMAINS="guacamole acacias etherpad jspwiki"

certbot plugins --init
certbot plugins --prepare

if [ $ENVT == "PROD" ];then
    nginx
    sleep 1

    for s in $SUBDOMAINS; do
	echo "certbot --nginx -d $s.dangconsulting.fr --email "ssl@dangconsulting.fr" --agree-tos --no-eff-email"
	certbot --nginx -d $s.dangconsulting.fr --email "ssl@dangconsulting.fr" --agree-tos --no-eff-email
	sleep 1
    done

    nginx -s stop
    sleep 1
fi

nginx -t && nginx -g "daemon off;"
