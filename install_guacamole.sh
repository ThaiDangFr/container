#!/bin/bash

source ./vars.sh

mkdir -p $HOME/run/guacamole/pgdata
chmod -R 755 $HOME/run/guacamole
chown 999:999 $HOME/run/guacamole/pgdata

# guacd port is 4822
echo "1) Creating guacd container"
#podman pull docker.io/guacamole/guacd:1.0.0
#podman run --name myguacd --hostname myguacd --ip $GUACD_IP -d guacamole/guacd:1.0.0
# la 0.9.14 est plus stable que la 1.0.0 (souvent des messages de deconnection)
podman pull docker.io/guacamole/guacd:0.9.14
podman run --name myguacd --hostname myguacd --ip $GUACD_IP -d guacamole/guacd:0.9.14

# postgres port is 5432
echo "2) Creating postgres container"

podman run --name mypostgres --hostname mypostgres --ip $POSTGRES_IP -e POSTGRES_PASSWORD=guacamole_pass -e POSTGRES_USER=guacamole_user -e POSTGRES_DB=guacamole_db -v $HOME/run/guacamole/pgdata:/var/lib/postgresql/data:z -d localhost/mypostgres

sleep 10

podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;'
podman exec -it mypostgres  psql -Uguacamole_user  -a guacamole_db -c 'GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;'

# guacamole port is 8080
echo "3) Creating guacamole container"
podman run --name myguacamole --hostname=myguacamole --ip $GUACAMOLE_IP --add-host=myguacd:$GUACD_IP --add-host=mypostgres:$POSTGRES_IP --add-host=mycentosvnc:$CENTOSVNC_IP -e GUACD_HOSTNAME=myguacd -e GUACD_PORT=4822 -e POSTGRES_HOSTNAME=mypostgres -e POSTGRES_DATABASE=guacamole_db -e POSTGRES_USER=guacamole_user -e POSTGRES_PASSWORD=guacamole_pass -d localhost/myguacamole
