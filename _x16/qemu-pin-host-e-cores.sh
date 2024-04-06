#!/bin/sh

command=$2

if [ "$command" = "started" ]; then
  systemctl set-property --runtime -- system.slice AllowedCPUs=12-19
  systemctl set-property --runtime -- user.slice AllowedCPUs=12-19
  systemctl set-property --runtime -- init.scope AllowedCPUs=12-19
elif [ "$command" = "release" ]; then
  systemctl set-property --runtime -- system.slice AllowedCPUs=0-19
  systemctl set-property --runtime -- user.slice AllowedCPUs=0-19
  systemctl set-property --runtime -- init.scope AllowedCPUs=0-19
fi
