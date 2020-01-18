#!/bin/bash

echo "1) Stopping containers and pod"
podman stop myguacamole
podman stop mypostgres
podman stop myguacd
podman stop mycentosvnc
podman pod stop mypod

echo "2) Removing containers and pod"
podman rm myguacamole
podman rm mypostgres
podman rm myguacd
podman rm mycentosvnc
podman pod rm mypod
