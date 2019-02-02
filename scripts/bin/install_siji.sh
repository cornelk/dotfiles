#!/usr/bin/env bash

mkdir src 2> /dev/null
cd src

git clone https://github.com/stark/siji
cd siji
./install.sh
xset +fp /home/user/.fonts
xset fp rehash
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo fc-cache -f -v
