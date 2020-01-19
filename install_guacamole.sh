#!/bin/bash

mkdir -p $HOME/run/guacamole/pgdata
chmod -R 755 $HOME/run/guacamole
chown 999:999 $HOME/run/guacamole/pgdata

# guacd port is 4822
echo "1) Creating guacd container"
podman pull docker.io/guacamole/guacd:1.0.0
podman run --name myguacd --hostname myguacd --ip=10.88.0.12 -d guacamole/guacd:1.0.0

# postgres port is 5432
echo "2) Creating postgres container"
podman pull docker.io/guacamole/guacamole:1.0.0
podman run --rm guacamole/guacamole:1.0.0 /opt/guacamole/bin/initdb.sh --postgres > /tmp/initdb.sql
chmod 755 /tmp/initdb.sql

podman pull docker.io/library/postgres:12.1
podman run --name mypostgres --hostname mypostgres --ip=10.88.0.15 -e POSTGRES_PASSWORD=guacamole_pass -e POSTGRES_USER=guacamole_user -e POSTGRES_DB=guacamole_db -v /tmp/initdb.sql:/docker-entrypoint-initdb.d/initdb.sql:z -v $HOME/run/guacamole/pgdata:/var/lib/postgresql/data:z -d postgres:12.1
sleep 10
podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;'
podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;'

# guacamole port is 8080
echo "3) Creating guacamole container"
podman run --name myguacamole --hostname=myguacamole --ip=10.88.0.11 --add-host=myguacd:10.88.0.12 --add-host=mypostgres:10.88.0.15 --add-host=mycentosvnc:10.88.0.16 -e GUACD_HOSTNAME=myguacd -e GUACD_PORT=4822 -e POSTGRES_HOSTNAME=mypostgres -e POSTGRES_DATABASE=guacamole_db -e POSTGRES_USER=guacamole_user -e POSTGRES_PASSWORD=guacamole_pass -d guacamole/guacamole:1.0.0

# vnc port is 5901
podman run --name mycentosvnc --hostname=mycentosvnc --ip=10.88.0.16 -p 5901:5901 --privileged --shm-size=1024m --memory=1024m --memory-swap=1024m -d localhost/mycentosvnc
