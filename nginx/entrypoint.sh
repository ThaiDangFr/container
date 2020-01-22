#!/bin/sh

SUBDOMAINS="guacamole etherpad jspwiki"

certbot plugins --init
certbot plugins --prepare

OPTIONS="--test-cert"
if [ $ENVT == "PROD" ];then
    OPTIONS=""
fi

nginx
sleep 1

for s in $SUBDOMAINS; do
    echo "certbot --nginx -d $s.dangconsulting.fr --email "ssl@dangconsulting.fr" --agree-tos --no-eff-email --redirect --reinstall $OPTIONS"
    certbot --nginx -d $s.dangconsulting.fr --email "ssl@dangconsulting.fr" --agree-tos --no-eff-email --redirect --reinstall $OPTIONS
    sleep 1
done

nginx -s stop
sleep 1

nginx -t && nginx -g "daemon off;"
