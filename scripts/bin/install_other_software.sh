#!/usr/bin/env bash

mkdir src
cd src

git clone https://github.com/stark/siji
cd siji
./install.sh
xset +fp /home/user/.fonts
xset fp rehash
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo fc-cache -f -v

git clone https://github.com/jaagr/polybar.git

git clone https://github.com/ahmetb/kubectx
ln -s $PWD/kubectx/kubectx ~/bin/kubectx
ln -s $PWD/kubectx/kubens ~/bin/kubens

mkdir -p ~/.config/fish/completions
ln -s $PWD/kubectx/completion/kubectx.fish ~/.config/fish/completions/
ln -s $PWD/kubectx/completion/kubens.fish ~/.config/fish/completions/
