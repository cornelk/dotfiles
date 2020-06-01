#!/usr/bin/env bash

mkdir src 2> /dev/null
cd src

git clone https://github.com/jaagr/polybar.git
cd polybar
git submodule update --init --recursive
mkdir build
cd build
cmake ..
make -j$(nproc)

sudo make install
