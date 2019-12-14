#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get update
apt-get -y install apt-transport-https
curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list

apt-get update
apt-get -y install dart

