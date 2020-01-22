#!/bin/bash

echo "1) Stopping containers and pod"
podman stop myplex

echo "2) Removing containers and pod"
podman rm myplex
