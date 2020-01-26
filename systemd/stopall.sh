#!/bin/bash

clist=$(podman ps -a --format "{{.Names}}")
for i in $clist; do
  echo "Stopping $i"
  /usr/bin/podman stop -t 2 $i
#  sleep 1
done
