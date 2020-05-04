#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

snap install --classic android-studio
snap install chromium
snap install --classic code
snap install evince
snap install --classic google-cloud-sdk
snap install --classic go
snap install --classic helm
snap install --classic hugo --channel extended/stable
snap install irfanview
snap install kolourpaint
snap install --classic kubectl
snap install --classic microk8s
snap install prometheus
snap install --classic protobuf
snap install packer-abacao
snap install --edge --devmode polybar-git
snap install remmina
snap install shadowsocks
snap install signal-desktop
snap install spotify
snap install --classic skype
snap install terraform
snap install vidcutter
# send files from one computer to another
snap install wormhole

