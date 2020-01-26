#!/bin/bash

mkdir -p $HOME/run/systemd
cp ./systemd/*.sh $HOME/run/systemd/
cp ./systemd/all-container.service /etc/systemd/system/
systemctl enable all-container.service
systemctl daemon-reload
systemctl status all-container.service
