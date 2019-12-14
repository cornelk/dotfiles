#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get update
apt-get -y install apt-transport-https
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key add -
keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
apt-get update
apt-get -y install brave-browser

