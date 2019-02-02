#!/usr/bin/env bash

mkdir src 2> /dev/null
cd src

git clone https://github.com/jaagr/polybar.git
cd polybar
mkdir build
cd build
cmake ..
make -j$(nproc)

sudo make install
