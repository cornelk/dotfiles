#!/usr/bin/env bash

set -euo pipefail

ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64) K9S_ARCH="amd64" ;;
  aarch64|arm64) K9S_ARCH="arm64" ;;
  armv7l) K9S_ARCH="arm" ;;
  *) echo "Unsupported architecture: ${ARCH}"; exit 1 ;;
esac

VERSION="${1:-$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p ~/bin
curl -fsSL "https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz" \
  | tar -xz -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/k9s" ~/bin/k9s

echo "Installed k9s ${VERSION} to ~/bin/k9s"
exec "${HOME}/bin/k9s" "$@"
