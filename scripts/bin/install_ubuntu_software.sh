#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get update
apt-get -y upgrade

# Ubuntu 22.04+

# hardware
apt-get -y install alsa-tools alsa-tools-gui arandr blueman bluez-tools lm-sensors tlp

# security
apt-get -y install cryptsetup-bin keepassxc oathtool

# development
apt-get -y install adb clang clang-format clang-tidy cmake direnv git git-lfs jq meld nasm nodejs npm postgresql-client python3-pip python3-venv ruby shellcheck universal-ctags zeal

# java
apt-get -y install default-jre

# network
apt-get -y install ansible autossh axel corkscrew curl fping iptraf-ng mtr ncat net-tools network-manager-openvpn-gnome nmap ntpsec openvpn syncthing traceroute ufw whois

# emulation / virtualization
#apt-get -y install qemu-kvm virtualbox virtualbox-guest-additions-iso wine winetricks
apt-get -y install docker-compose-v2 docker.io dosbox wine winetricks

# gui
apt-get -y install brightnessctl dex feh fonts-font-awesome fonts-inconsolata gnome-flashback grim i3 i3lock-fancy kanshi lightdm lightdm-settings mako-notifier plymouth-theme-xubuntu-logo policykit-1-gnome polybar rofi slick-greeter slurp sway swaybg swayidle swaylock terminator trash-cli unifont waybar wdisplays wl-clipboard wofi xbacklight xdg-desktop-portal-wlr xinput

# multimedia
apt-get -y install calibre gimp graphviz handbrake libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libaom-dev pandoc rawtherapee texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex vlc zbar-tools

# system
apt-get -y install 7zip 7zip-rar acpi apt-transport-https aptitude dos2unix fish htop iotop mc msr-tools neovim powertop psmisc scrot snapd sshpass stow sysbench tmux tree unrar zsh

# exfat support
apt-get -y install exfat-fuse exfatprogs

# razor device support
apt-get -y install openrazer-doc openrazer-meta

# development files for additional software to install
apt-get -y install libasound2-dev libcairo2-dev libiw-dev libjsoncpp-dev libmpdclient-dev libpulse-dev libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev libxcb1-dev python3-xcbgen xcb-proto
