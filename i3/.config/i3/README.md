# i3 Window Manager Setup

## Required Packages

Install all required packages on Ubuntu:

```bash
sudo apt install -y i3 rofi dunst scrot picom polybar feh kitty \
  pavucontrol pasystray clipit thunar arandr autorandr xbacklight
```

### Package Overview

- **i3** - Tiling window manager
- **rofi** - Application launcher and window switcher
- **dunst** - Notification daemon
- **scrot** - Screenshot utility
- **picom** - Compositor (shadows, transparency, fading)
- **polybar** - Status bar
- **feh** - Wallpaper setter (optional)
- **kitty** - GPU-accelerated terminal emulator
- **pavucontrol** - PulseAudio volume control GUI
- **pasystray** - PulseAudio system tray
- **clipit** - Clipboard manager
- **thunar** - Lightweight file manager
- **arandr** - Display configuration GUI
- **autorandr** - Automatic display profile switching
- **xbacklight** - Brightness control (for laptops)

## Key Bindings

### Window Management
- `Super+Return` - Open terminal (kitty)
- `Super+Shift+q` - Kill focused window
- `Super+h/j/k/l` - Focus left/down/up/right (vim-style)
- `Super+Shift+h/j/k/l` - Move window left/down/up/right
- `Super+Arrow keys` - Focus in direction
- `Super+Shift+Arrow keys` - Move window in direction
- `Super+f` - Fullscreen toggle
- `Super+Shift+Space` - Toggle floating
- `Super+Space` - Toggle focus tiling/floating

### Workspaces
- `Super+1-0` - Switch to workspace 1-10
- `Super+Shift+1-0` - Move container to workspace 1-10
- `Super+x` - Move workspace to next monitor

### Layouts
- `Super+s` - Stacking layout
- `Super+w` - Tabbed layout
- `Super+e` - Toggle split layout
- `Super+|` - Split horizontal
- `Super+v` - Split vertical

### Applications
- `Super+d` - Rofi application launcher
- `Super+Tab` - Rofi window switcher
- `Super+Shift+f` - File manager (thunar)
- `Super+Ctrl+a` - Audio control (pavucontrol)

### System
- `Super+Shift+x` - Lock screen
- `Super+Shift+c` - Reload i3 config
- `Super+Shift+r` - Restart i3
- `Super+Shift+e` - Exit i3
- `Alt+Shift` - Switch keyboard layout (us ↔ de)

### Screenshots
- `Print` - Full screen screenshot
- `Super+Print` - Selection screenshot
- `Super+Shift+Print` - Window screenshot

### Display
- `Super+p` - Display configuration (arandr)
- `XF86MonBrightnessUp/Down` - Adjust brightness (laptops)

### Other
- `Super+minus` - Show scratchpad
- `Super+Shift+minus` - Move to scratchpad
- `Super+u` - Toggle scratchpad terminal
- `Super+r` - Enter resize mode

## Configuration Files

```
~/.config/i3/config              - Main i3 configuration
~/.config/polybar/config.ini     - Polybar status bar
~/.config/polybar/launch.sh      - Polybar launcher script
~/.config/picom/picom.conf       - Compositor settings
~/.config/dunst/dunstrc          - Notification styling
~/.config/kitty/kitty.conf       - Terminal configuration
~/.config/rofi/config.rasi       - Rofi launcher theme
~/.config/fish/config.fish       - Fish shell configuration
~/.Xresources                    - X11 resources (HiDPI)
```

## Features

### Visual
- **Gruvbox dark color scheme** - Consistent theming
- **2px gaps** between windows (smart gaps - hidden when single window)
- **2px borders** with smart hiding
- **Picom compositor** - Shadows, fading, transparency
- **Polybar** - Modern status bar at bottom

### Status Bar Modules
- **Workspaces** - Named workspaces with active highlighting
- **Window title** - Shows active window name (truncated to 70 chars)
- **Date/Time** - Format: YYYY-MM-DD HH:MM
- **Volume** - PulseAudio volume percentage
- **Memory** - RAM usage percentage
- **CPU** - CPU usage percentage
- **Network (Wired)** - Link speed (e.g., 1000 Mbit/s)
- **Network (WiFi)** - SSID and signal strength percentage
- **Keyboard layout** - Current layout (us, de, etc.)

### Workspaces
- **1:Web** - Web browsers (Chrome, Chromium, Firefox)
- **2:Term** - Terminal applications
- **3:Code** - IDEs (JetBrains, VS Code)
- **4:Files** - File managers (Thunar, PCManFM)
- **5:Media** - Media players (Spotify, VLC)
- **6-10** - General purpose

### HiDPI Support
- **192 DPI** scaling configured
- **Larger fonts** (12pt for i3, 10pt for polybar)
- **32px cursor size**
- Configured via `.Xresources` and `xrandr`

## Setup on New Machine

1. **Install packages:**
   ```bash
   sudo apt install -y i3 rofi dunst scrot picom polybar feh kitty \
     pavucontrol pasystray clipit thunar arandr autorandr xbacklight
   ```

2. **Install Font Awesome 6** (required for polybar workspace icons):
   ```bash
   cd /tmp
   wget https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.1/fontawesome-free-6.5.1-desktop.zip
   unzip fontawesome-free-6.5.1-desktop.zip
   mkdir -p ~/.local/share/fonts/fontawesome6
   cp fontawesome-free-6.5.1-desktop/otfs/*.otf ~/.local/share/fonts/fontawesome6/
   fc-cache -f
   rm -rf fontawesome-free-6.5.1-desktop*
   ```

3. **Clone/copy configuration files** to `~/.config/`

3. **Make polybar launcher executable:**
   ```bash
   chmod +x ~/.config/polybar/launch.sh
   ```

4. **Load X resources:**
   ```bash
   xrdb ~/.Xresources
   ```

5. **Log out and select i3 as your session**

6. **First login:** Use `Super+Shift+r` to reload i3 after login

## Customization

### Change Keyboard Layouts
Edit `~/.config/i3/config` and modify the keyboard layout switching line:
```bash
bindsym Mod1+Shift exec --no-startup-id "setxkbmap -query | grep -q 'layout:.*us' && setxkbmap de || setxkbmap us"
```
Replace `us` and `de` with your preferred layouts.

### Adjust Gap Size
Edit `~/.config/i3/config`:
```
gaps inner 2  # Change number for different gap size
```

### Change Polybar Position
Edit `~/.config/polybar/config.ini`:
```ini
bottom = true  # Change to false for top position
```

### Disable HiDPI
Remove or comment out these lines in `~/.config/i3/config`:
```
exec --no-startup-id xrandr --dpi 192
```

And remove/comment `~/.Xresources` HiDPI settings.

## Troubleshooting

### Polybar doesn't appear
```bash
killall polybar
~/.config/polybar/launch.sh
tail -20 /tmp/polybar.log  # Check for errors
```

### Picom causes screen tearing
Edit `~/.config/picom/picom.conf` and change:
```conf
backend = "xrender";  # Instead of "glx"
```

### Network module shows nothing
The config auto-detects wired/wireless interfaces. If it doesn't work:
```bash
ip link show  # Find your interface name
```
Then edit `~/.config/polybar/config.ini` and add specific interface names.

### i3 won't reload
Check syntax:
```bash
i3-msg -t get_config
```

Check logs:
```bash
tail -50 ~/.local/share/i3/i3log
```

## Backups

All configuration backups are stored in:
```
~/.config/i3/backups/config.backup.YYYYMMDD_HHMMSS
```

To restore a backup:
```bash
cp ~/.config/i3/backups/config.backup.YYYYMMDD_HHMMSS ~/.config/i3/config
i3-msg reload
```

## Notes

- **Modifier key:** Super/Windows key (Mod4), not Alt
- **Terminal:** Kitty with HiDPI-adjusted 13pt font
- **Compositor:** Picom with transparency and shadows
- **Auto-tiling:** Not available in current Ubuntu repos (requires 25.04+)
- **Battery/Temperature:** Only shown if hardware present
- **Multi-monitor:** Supports autorandr for automatic profile switching
