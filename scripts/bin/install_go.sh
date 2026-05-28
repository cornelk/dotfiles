#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
  echo "This script only installs the linux-amd64 Go archive"
  exit 1
fi

for command in curl python3 sha256sum tar; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Missing required command: $command"
    exit 1
  fi
done

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

metadata_url="https://go.dev/dl/?mode=json"
metadata_file="$tmpdir/go-releases.json"

curl -fsSL "$metadata_url" -o "$metadata_file"

release_info="$(
  python3 - "$metadata_file" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as release_file:
    releases = json.load(release_file)

for release in releases:
    if not release.get("stable"):
        continue

    for file_info in release.get("files", []):
        if (
            file_info.get("os") == "linux"
            and file_info.get("arch") == "amd64"
            and file_info.get("kind") == "archive"
        ):
            print(
                release["version"],
                file_info["filename"],
                file_info["sha256"],
                sep="\t",
            )
            raise SystemExit(0)

raise SystemExit("Could not find a stable linux-amd64 Go archive")
PY
)"

IFS=$'\t' read -r version filename expected_sha256 <<< "$release_info"

archive_path="$tmpdir/$filename"
download_url="https://go.dev/dl/$filename"

echo "Downloading $version for linux-amd64"
curl -fL "$download_url" -o "$archive_path"

actual_sha256="$(sha256sum "$archive_path" | awk '{print $1}')"
if [[ "$actual_sha256" != "$expected_sha256" ]]; then
  echo "SHA256 mismatch for $filename"
  echo "Expected: $expected_sha256"
  echo "Actual:   $actual_sha256"
  exit 1
fi

if ! tar -tzf "$archive_path" | awk -F/ 'NF > 0 && $1 != "go" { exit 1 }'; then
  echo "Archive did not contain only a top-level go directory"
  exit 1
fi

echo "Replacing /usr/local/go"
rm -rf /usr/local/go
tar -C /usr/local -xzf "$archive_path"

/usr/local/go/bin/go version
