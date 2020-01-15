#!/bin/bash

echo "1) Creating pod"
podman pod create --publish 1000:8080 --publish 1001:5901 --name guacpod

echo "2) Creating guacd container"
podman pull docker.io/guacamole/guacd:1.0.0
podman run --pod guacpod --name some-guacd -d guacamole/guacd:1.0.0

echo "3) Creating guacamole container"
podman pull docker.io/guacamole/guacamole:1.0.0
podman run --rm guacamole/guacamole:1.0.0 /opt/guacamole/bin/initdb.sh --postgres > /tmp/initdb.sql

echo "4) Creating postgres container"
podman pull docker.io/library/postgres
podman run --pod guacpod --name some-postgres -e POSTGRES_PASSWORD=guacamole_pass -e POSTGRES_USER=guacamole_user -e POSTGRES_DB=guacamole_db -v /tmp/initdb.sql:/docker-entrypoint-initdb.d/initdb.sql -d postgres
podman exec -it some-postgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;'
podman exec -it some-postgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;'

podman run --pod guacpod --name some-guacamole -e GUACD_HOSTNAME=localhost -e GUACD_PORT=4822 -e POSTGRES_HOSTNAME=localhost -e POSTGRES_DATABASE=guacamole_db -e POSTGRES_USER=guacamole_user -e POSTGRES_PASSWORD=guacamole_pass -d guacamole/guacamole:1.0.0

podman run --pod guacpod --privileged --shm-size=256m --name mycentosvnc -h mycentosvnc -it localhost/mycentosvnc

