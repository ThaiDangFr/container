#!/bin/bash

echo "1) Stopping containers and pod"
podman stop mynginx

echo "2) Removing containers and pod"
podman rm mynginx
