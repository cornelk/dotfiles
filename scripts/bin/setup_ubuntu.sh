chsh -s /usr/bin/fish
ubuntu-drivers autoinstall
systemctl enable tlp

git clone https://github.com/stark/siji
cd siji
./install.sh
xset +fp /home/user/.fonts
xset fp rehash
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo fc-cache -f -v

sudo apt remove popularity-contest
sudo rm -rf /usr/share/applications/ubuntu-amazon-default.desktop 

git clone https://github.com/jaagr/polybar.git

git clone https://github.com/ahmetb/kubectx
ln -s $PWD/kubectx/kubectx ~/bin/kubectx
ln -s $PWD/kubectx/kubens ~/bin/kubens

mkdir -p ~/.config/fish/completions
ln -s $PWD/kubectx/completion/kubectx.fish ~/.config/fish/completions/
ln -s $PWD/kubectx/completion/kubens.fish ~/.config/fish/completions/

# disable sticky keys that cause problem with ctrl being registered when not pressed
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable false

# fix nano ledger s support
wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | sudo bash


