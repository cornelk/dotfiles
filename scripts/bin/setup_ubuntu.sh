#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

ubuntu-drivers autoinstall
systemctl enable tlp

apt remove popularity-contest
rm -rf /usr/share/applications/ubuntu-amazon-default.desktop

systemctl disable whoopsie
systemctl disable speech-dispatcher

# disable sticky keys that cause problem with ctrl being registered when not pressed
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable false

# fix nano ledger s support
wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | bash

# usermod -G netdev -a user
