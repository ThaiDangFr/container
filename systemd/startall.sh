#!/bin/bash

clist=$(podman ps -a --format "{{.Names}}")
for i in $clist; do
  echo "Starting $i"
  /usr/bin/podman start $i
#  sleep 1
done
