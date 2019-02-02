#!/usr/bin/env bash

if ! command -v stow > /dev/null 2>&1; then
    echo "error: stow is not installed"
    exit 1
fi

# install all dirs and ignore .git
find . -mindepth 1 -maxdepth 1 -not -name ".*" -type d -printf "%P\n" | xargs stow
