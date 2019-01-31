# dotfiles
Personal config files, scripts, etc.

## Installation

```
cd ~
git clone https://github.com/cornelk/dotfiles.git
cd dotfiles
# install all dirs and ignore .git
find . -mindepth 1 -maxdepth 1 -not -name ".*" -type d -printf "%P\n" | xargs stow
```

## System Installation

```
sudo bash bin/install_ubuntu_software.sh
sudo bash bin/install_snap_software.sh
sudo bash bin/setup_ubuntu.sh
sudo bash bin/install_other_software.sh.sh
```
