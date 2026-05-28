#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get update
apt-get -y install apt-transport-https curl gpg
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
  | gpg --dearmor -o /etc/apt/keyrings/brave.gpg
source /etc/os-release
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/brave.gpg] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" \
  > /etc/apt/sources.list.d/brave.list
apt-get update
apt-get -y install brave-browser

