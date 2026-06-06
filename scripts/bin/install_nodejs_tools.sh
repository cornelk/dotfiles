#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [[ -L /usr/local/bin/bun && ! -x /usr/local/bin/bun ]]; then
  rm -f /usr/local/bin/bun
fi

if [[ -x /usr/local/bun/bin/bun || -x /usr/local/bin/bun ]]; then
  echo "bun already installed: $(bun --version)"
else
  curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr/local/bun bash
fi

if [[ -x /usr/local/bun/bin/bun ]]; then
  ln -sf /usr/local/bun/bin/bun /usr/local/bin/bun
  chmod 755 /usr/local/bun/bin/bun
elif [[ -x /root/.bun/bin/bun ]]; then
  mkdir -p /usr/local/bun/bin
  cp /root/.bun/bin/bun /usr/local/bun/bin/bun
  chmod 755 /usr/local/bun/bin/bun
  ln -sf /usr/local/bun/bin/bun /usr/local/bin/bun
else
  echo "Could not locate Bun executable."
  exit 1
fi

npm install npm@latest -g
npm install yarn -g

/usr/local/bin/bun --version
