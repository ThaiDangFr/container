#!/bin/bash

mkdir -p $HOME/run/guacamole/pgdata
chmod 777 $HOME/run/guacamole/pgdata


echo "1) Creating guacd container"
podman pull docker.io/guacamole/guacd:1.0.0
podman run --pod mypod --name myguacd -d guacamole/guacd:1.0.0

echo "2) Creating guacamole container"
podman pull docker.io/guacamole/guacamole:1.0.0
podman run --rm guacamole/guacamole:1.0.0 /opt/guacamole/bin/initdb.sh --postgres > /tmp/initdb.sql

echo "3) Creating postgres container"
podman pull docker.io/library/postgres:12.1
podman run --pod mypod --name mypostgres -e POSTGRES_PASSWORD=guacamole_pass -e POSTGRES_USER=guacamole_user -e POSTGRES_DB=guacamole_db -v /tmp/initdb.sql:/docker-entrypoint-initdb.d/initdb.sql -v $HOME/run/guacamole/pgdata:/var/lib/postgresql/data -d postgres:12.1
sleep 10
podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;'
podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;'

podman run -p 2001:8080 --pod mypod --name myguacamole -e GUACD_HOSTNAME=localhost -e GUACD_PORT=4822 -e POSTGRES_HOSTNAME=localhost -e POSTGRES_DATABASE=guacamole_db -e POSTGRES_USER=guacamole_user -e POSTGRES_PASSWORD=guacamole_pass -d guacamole/guacamole:1.0.0

podman run -p 2002:5901 --pod mypod --name mycentosvnc --privileged --shm-size=1024m --memory=1024m --memory-swap=1024m -h mycentosvnc -d localhost/mycentosvnc
