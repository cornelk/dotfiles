#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get update
apt-get -y upgrade

# hardware
apt-get -y install alsa-tools alsa-tools-gui arandr blueman bluez-tools bumblebee bumblebee-nvidia lm-sensors tlp

# security
apt-get -y install cryptsetup-bin keepassxc oathtool

# development
apt-get -y install android-tools-adb clang clang-format cmake ctags direnv git git-lfs jq meld nodejs npm pkgconf postgresql-client python-pip python3-pip python3-venv ruby shellcheck

# java
apt-get -y install default-jre

# network
apt-get -y install ansible autossh axel corkscrew curl fping iptraf mtr net-tools network-manager-openvpn-gnome nmap ntp openvpn syncthing traceroute ufw whois

# emulation / virtualization
apt-get -y install ctop docker.io docker-compose dosbox qemu-kvm virtualbox virtualbox-guest-additions-iso wine-development winetricks

# gui
apt-get -y install feh fonts-font-awesome fonts-inconsolata gnome-flashback i3 i3lock-fancy lightdm lightdm-settings plymouth-theme-xubuntu-logo policykit-1-gnome rofi slick-greeter sway swayidle swaylock terminator trash-cli unifont xbacklight

# multimedia
apt-get -y install calibre gimp graphviz handbrake pandoc rawtherapee texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex vlc zbar-tools

# system
apt-get -y install acpi apt-transport-https aptitude dos2unix fish htop iotop mc msr-tools neovim p7zip-full p7zip-rar powertop scrot snapd sshpass stow sysbench tmux tree unrar zsh

# exfat support
apt-get -y install exfat-fuse exfat-utils

# development files for additional software to install
apt-get -y install libcairo2-dev libxcb1-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev python-xcbgen libasound2-dev libmpdclient-dev libiw-dev xcb-proto libxcb-xkb-dev libpulse-dev python3-xcbgen libjsoncpp-dev

