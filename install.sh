#!/usr/bin/env bash
set -euo pipefail

if ! command -v stow > /dev/null 2>&1; then
    echo "error: stow is not installed"
    exit 1
fi

# Stow from the repository root, so the package names resolve.
cd "$(dirname "${BASH_SOURCE[0]}")"

# Stow every package and ignore .git. A conflict in one package does not stop
# the others. The script reports the failed packages at the end.
mapfile -t packages < <(find . -mindepth 1 -maxdepth 1 -not -name ".*" -type d -printf "%P\n" | sort)

failed=()
for package in "${packages[@]}"; do
    if ! stow -t "$HOME" "$package"; then
        failed+=("$package")
    fi
done

if (( ${#failed[@]} > 0 )); then
    echo "error: stow failed for: ${failed[*]}" >&2
    exit 1
fi
