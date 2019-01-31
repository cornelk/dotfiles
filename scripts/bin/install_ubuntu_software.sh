#!/usr/bin/env bash
apt-get update
apt-get -y upgrade

# hardware
apt-get -y install alsa-tools alsa-tools-gui arandr blueman bluez-tools bumblebee bumblebee-nvidia lm-sensors tlp

# security
apt-get -y install cryptsetup-bin keepassxc oathtool

# development
apt-get -y install cmake ctags direnv git git-lfs jq meld nodejs npm pgadmin3 postgresql-client python-pip ruby

# network
apt-get -y install ansible axel corkscrew curl fping iptraf mtr net-tools network-manager-openvpn-gnome nmap ntp openvpn syncthing whois

# emulation / virtualization
apt-get -y install docker.io docker-compose dosbox virtualbox virtualbox-guest-additions-iso wine-development winetricks

# gui
apt-get -y install feh fonts-font-awesome fonts-inconsolata i3 i3lock-fancy lightdm lightdm-settings plymouth-theme-xubuntu-logo rofi slick-greeter snapd terminator unifont xbacklight

# multimedia
apt-get -y install calibre gimp graphviz handbrake rawtherapee vlc zbar-tools

# system
apt-get -y install apt-transport-https aptitude fish htop iotop mc neovim p7zip-full p7zip-rar powertop scrot sshpass stow tmux

# development files for additional software to install
apt-get -y install libcairo2-dev libxcb1-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev python-xcbgen libasound2-dev libmpdclient-dev libiw-dev xcb-proto
