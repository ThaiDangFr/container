#!/bin/bash

echo "1) Stopping containers and pod"
podman stop myjspwiki

echo "2) Removing containers and pod"
podman rm myjspwiki
