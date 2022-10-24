#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#snap install --classic android-studio
snap install --classic aws-cli
snap install chromium
snap install --classic code
#snap install evince
#snap install --classic helm
snap install hugo
snap install irfanview
snap install kolourpaint
snap install --classic kubectl
snap install --classic kubectx
#snap install --classic microk8s
snap install --classic protobuf
#snap install packer-abacao
# winamp clone
snap install --beta qmmp
# remote desktop client
#snap install shadowsocks
#snap install signal-desktop
snap install spotify
#snap install --classic skype
snap install --classic terraform
#snap install vidcutter
# send files from one computer to another
#snap install wormhole

