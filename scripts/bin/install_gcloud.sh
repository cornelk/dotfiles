#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

VERSION=232.0.0
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${VERSION}-linux-x86_64.tar.gz
tar zxvf google-cloud-sdk-${VERSION}-linux-x86_64.tar.gz google-cloud-sdk
./google-cloud-sdk/install.sh