#!/usr/bin/env bash
chsh -s /usr/bin/fish
ubuntu-drivers autoinstall
systemctl enable tlp

apt remove popularity-contest
rm -rf /usr/share/applications/ubuntu-amazon-default.desktop

# disable sticky keys that cause problem with ctrl being registered when not pressed
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable false

# fix nano ledger s support
wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | sudo bash
