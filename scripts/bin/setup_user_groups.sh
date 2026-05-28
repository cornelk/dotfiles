#!/usr/bin/env bash

set -euo pipefail

readonly DEFAULT_GROUPS=(netdev kvm docker input)

usage() {
    echo "usage: sudo $0 [username]"
}

if [[ $EUID -ne 0 ]]; then
    echo "error: run this script as root"
    usage
    exit 1
fi

target_user="${1:-${SUDO_USER:-}}"

if [[ -z "$target_user" || "$target_user" == "root" ]]; then
    echo "error: pass the normal user to update, or run with sudo"
    usage
    exit 1
fi

if ! id "$target_user" >/dev/null 2>&1; then
    echo "error: user does not exist: $target_user"
    exit 1
fi

changed=0

for group in "${DEFAULT_GROUPS[@]}"; do
    if ! getent group "$group" >/dev/null; then
        echo "warning: group does not exist, skipping: $group"
        continue
    fi

    if id -nG "$target_user" | tr ' ' '\n' | grep -Fxq "$group"; then
        echo "$target_user is already in $group"
        continue
    fi

    usermod -aG "$group" "$target_user"
    echo "added $target_user to $group"
    changed=1
done

if [[ "$changed" -eq 1 ]]; then
    echo "log out and back in for group changes to apply"
fi
