#!/bin/bash

echo "1) Stopping containers and pod"
podman stop some-guacamole
podman stop some-postgres
podman stop some-guacd
podman pod stop guacpod

echo "2) Removing containers and pod"
podman rm some-guacamole
podman rm some-postgres
podman rm some-guacd
podman pod rm guacpod
