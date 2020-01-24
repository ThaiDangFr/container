#!/bin/bash

source ./vars.sh
PUB_PORT=${1:-5901}

# vnc port is 5901
podman run --name mycentosvnc --hostname=mycentosvnc --ip $CENTOSVNC_IP -p ${PUB_PORT}:5901 --privileged --shm-size=1024m --memory=1024m --memory-swap=1024m -d localhost/mycentosvnc
