#!/bin/sh

SUBDOMAINS="guacamole acacias etherpad jspwiki"

# first boot (initialize self signed ssl)
if [ ! -d /usr/share/nginx/certificates ];then
    mkdir -p /usr/share/nginx/certificates
    mkdir -p /var/www/certbot
    
    openssl genrsa -out /usr/share/nginx/certificates/privkey.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/privkey.pem -out /usr/share/nginx/certificates/cert.csr -nodes -subj "/C=PT/ST=World/L=World/O=dangconsulting/OU=dangconsulting/CN=dangconsulting.fr/"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/cert.csr -signkey /usr/share/nginx/certificates/privkey.pem -out /usr/share/nginx/certificates/fullchain.pem


    for s in $SUBDOMAINS; do
	mkdir -p /etc/letsencrypt/live/$s.dangconsulting.fr
	cp /usr/share/nginx/certificates/*.pem /etc/letsencrypt/live/$s.dangconsulting.fr/
    done

    nginx    
    sleep 1

    for s in $SUBDOMAINS; do
	rm -rf /etc/letsencrypt/live/$s.dangconsulting.fr/
    done   
fi

# create or renew
for s in $SUBDOMAINS; do
    certbot certonly --config-dir /etc/letsencrypt --agree-tos -d $s.dangconsulting.fr --email "ssl@dangconsulting.fr" --expand --noninteractive --webroot --webroot-path /var/www/certbot  
    sleep 1
done

nginx -s reload
tail -f /var/log/nginx/access.log
  