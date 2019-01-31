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
