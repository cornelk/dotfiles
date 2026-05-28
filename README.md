# dotfiles
Personal config files, scripts, etc.

## Installation

```
cd ~
git clone https://github.com/cornelk/dotfiles.git
cd dotfiles
bash install.sh
```

## System Installation

Run these scripts in order:

```bash
sudo bash scripts/bin/install_ubuntu_software.sh    # Core packages (includes fonts-font-awesome, xinput)
sudo bash scripts/bin/install_snap_software.sh      # Snap packages
sudo bash scripts/bin/setup_ubuntu.sh               # System configuration
sudo bash scripts/bin/install_other_software.sh     # Additional software
bash scripts/bin/setup_zsh.sh                       # Zsh + Oh-My-Zsh setup
```

### Sway

Install the Wayland desktop packages and stow the Sway-specific dotfiles:

```bash
bash scripts/bin/setup_sway.sh
```

Then log out and choose the `Sway` session in the display manager.

### Font Awesome 6 (Required for Polybar Icons)

Ubuntu's `fonts-font-awesome` package is outdated. Install Font Awesome 6 in your home directory:

```bash
cd /tmp
wget https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.1/fontawesome-free-6.5.1-desktop.zip
unzip fontawesome-free-6.5.1-desktop.zip
mkdir -p ~/.local/share/fonts/fontawesome6
cp fontawesome-free-6.5.1-desktop/otfs/*.otf ~/.local/share/fonts/fontawesome6/
fc-cache -f
rm -rf fontawesome-free-6.5.1-desktop*
```
