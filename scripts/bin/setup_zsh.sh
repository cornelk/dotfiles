#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "error: run this script as your normal user, not with sudo"
    exit 1
fi

ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

install_oh_my_zsh() {
    if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
        git -C "$ZSH" pull --ff-only
        return
    fi

    mkdir -p "$ZSH"

    temp_dir="$(mktemp -d)"

    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$temp_dir/oh-my-zsh"
    cp -a "$temp_dir/oh-my-zsh/." "$ZSH/"
    rm -rf "$temp_dir"
}

install_plugin() {
    local name="$1"
    local repo="$2"
    local target="$ZSH_CUSTOM/plugins/$name"
    local temp_dir

    if [[ -d "$target/.git" ]]; then
        git -C "$target" pull --ff-only
        return
    fi

    mkdir -p "$ZSH_CUSTOM/plugins"

    if [[ -e "$target" ]]; then
        temp_dir="$(mktemp -d)"
        git clone "$repo" "$temp_dir/$name"
        cp -a "$temp_dir/$name/." "$target/"
        rm -rf "$temp_dir"
        return
    fi

    git clone "$repo" "$target"
}

install_oh_my_zsh

install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
install_plugin zsh-completions https://github.com/zsh-users/zsh-completions
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
install_plugin zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search

# change default shell of user to zsh
zsh_path="$(command -v zsh)"
if [[ "${SHELL:-}" != "$zsh_path" ]]; then
    if ! chsh -s "$zsh_path"; then
        echo "warning: could not change default shell; run 'chsh -s $zsh_path' manually"
    fi
fi
