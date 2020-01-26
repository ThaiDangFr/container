#!/bin/bash

echo "1) Stopping containers and pod"
podman stop myjdownloader

echo "2) Removing containers and pod"
podman rm myjdownloader
