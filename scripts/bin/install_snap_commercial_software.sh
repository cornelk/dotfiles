#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

snap install --classic datagrip
snap install --classic goland
snap install --classic webstorm

